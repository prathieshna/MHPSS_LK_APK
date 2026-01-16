import 'dart:typed_data';

import 'package:mhpss_app/core/resources/all_imports.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfReaderScreen extends ConsumerStatefulWidget {
  final String pdfLink;
  final String? filePath;
  final String? language;
  final bool isDownload;
  final SingleResourceDetails? resourceDetails;

  const PdfReaderScreen({
    super.key,
    required this.pdfLink,
    this.filePath,
    this.language,
    this.isDownload = false,
    this.resourceDetails,
  });

  @override
  ConsumerState<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends ConsumerState<PdfReaderScreen> {
  PdfController? pdfController;
  bool _isLoading = true;
  bool _loadError = false;

  // Helper function to convert Google Drive sharing links to direct download links
  String _convertGoogleDriveLink(String url) {
    // Check if it's a Google Drive link
    if (url.contains('drive.google.com')) {
      // Extract file ID from various Google Drive URL formats
      // Format 1: https://drive.google.com/file/d/FILE_ID/view
      RegExp fileIdRegex = RegExp(r'/d/([a-zA-Z0-9_-]+)');
      Match? match = fileIdRegex.firstMatch(url);

      if (match != null && match.groupCount > 0) {
        String fileId = match.group(1)!;
        // Convert to direct download link
        // Using uc?export=download format works better for PDFs
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }

      // Format 2: Already in id= format
      if (url.contains('id=')) {
        RegExp idRegex = RegExp(r'id=([a-zA-Z0-9_-]+)');
        Match? idMatch = idRegex.firstMatch(url);
        if (idMatch != null && idMatch.groupCount > 0) {
          String fileId = idMatch.group(1)!;
          return 'https://drive.google.com/uc?export=download&id=$fileId';
        }
      }

      // Format 3: Open link format
      // https://drive.google.com/open?id=FILE_ID
      if (url.contains('open?id=')) {
        RegExp openIdRegex = RegExp(r'open\?id=([a-zA-Z0-9_-]+)');
        Match? openMatch = openIdRegex.firstMatch(url);
        if (openMatch != null && openMatch.groupCount > 0) {
          String fileId = openMatch.group(1)!;
          return 'https://drive.google.com/uc?export=download&id=$fileId';
        }
      }
    }

    // Return original URL if not a Google Drive link
    return url;
  }

  @override
  void initState() {
    super.initState();
    _loadPdf();
    print(
        "pdfPath: ${widget.pdfLink}, language: ${widget.language}, isDownload: ${widget.isDownload}, resourceDetails: ${widget.resourceDetails?.toJson()}");
  }

  Future<void> _loadPdf() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _loadError = false;
    });

    try {
      late final Uint8List pdfBytes;

      if (widget.isDownload && widget.filePath != null) {
        // Handle local file reading for downloaded PDFs
        final file = File(widget.filePath!);
        if (!await file.exists()) {
          throw Exception('PDF file not found: ${widget.filePath}');
        }
        pdfBytes = await file.readAsBytes();
      } else if (widget.pdfLink.startsWith('http') ||
          widget.pdfLink.startsWith('https')) {
        // Web URL: download bytes with retry logic
        pdfBytes = await _downloadPdfWithRetry(widget.pdfLink);
      } else {
        // Local file path from pdfLink
        final file = File(widget.pdfLink);
        if (!await file.exists()) {
          throw Exception('PDF file not found: ${widget.pdfLink}');
        }
        pdfBytes = await file.readAsBytes();
      }

      if (!mounted) return;

      setState(() {
        pdfController = PdfController(document: PdfDocument.openData(pdfBytes));
        _isLoading = false;
        _loadError = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _loadError = true;
      });
      print('Error loading PDF: $e');
    }
  }

// New helper method with retry logic
  Future<Uint8List> _downloadPdfWithRetry(String url,
      {int maxRetries = 3}) async {
    int retryCount = 0;

    // Convert Google Drive links to direct download links
    final downloadUrl = _convertGoogleDriveLink(url);
    print("Original PDF URL: $url");
    print("Download PDF URL: $downloadUrl");

    while (retryCount < maxRetries) {
      try {
        final dio = Dio()
          ..options.connectTimeout = const Duration(seconds: 30)
          ..options.receiveTimeout = const Duration(seconds: 60)
          ..options.sendTimeout = const Duration(seconds: 30)
          ..options.followRedirects = true
          ..options.maxRedirects = 5;

        final response = await dio.get<List<int>>(
          downloadUrl,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            validateStatus: (status) => status! < 500,
            headers: {
              'Accept': 'application/pdf',
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            },
          ),
        );

        if (response.data == null || response.data!.isEmpty) {
          throw Exception('failed_to_download_pdf_empty_response'.tr());
        }

        final bytes = Uint8List.fromList(response.data!);

        // Check if the response is actually a PDF and not an HTML error page
        // PDF files start with "%PDF" (bytes: 0x25 0x50 0x44 0x46)
        if (bytes.length > 4) {
          final isPdf = bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46;
          if (!isPdf) {
            print("Response is not a PDF file. Might be an HTML page or error.");
            // For Google Drive, try the alternate download URL format
            if (url.contains('drive.google.com') && retryCount == 0) {
              print("Retrying with alternate Google Drive format");
              throw DioException(
                requestOptions: response.requestOptions,
                type: DioExceptionType.badResponse,
                message: "Not a PDF response",
              );
            }
          }
        }

        return bytes;
      } on DioException catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          // If this was our last retry, rethrow the exception
          if (e.type == DioExceptionType.connectionError) {
            throw Exception(
                'Connection error: Please check your internet connection and try again');
          } else {
            throw Exception(
                'Failed to download PDF after $maxRetries attempts: ${e.message}');
          }
        }

        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: 1 * retryCount));
        print('Retrying PDF download, attempt $retryCount');
      }
    }

    throw Exception('Failed to download PDF after multiple attempts');
  }

  Future<void> handleResourceDownload(
    BuildContext context, {
    required SingleResourceDetails? resourceData,
    required String lang,
  }) async {
    if (!mounted) return;

    // Validate resource and document availability
    // print("lang: $lang, resourceData: ${resourceData?.toJson()}");
    if (resourceData?.resourceDocument == null ||
        resourceData!.resourceDocument!.isEmpty) {
      Utils.displayToast("no_document_available".tr());
      return;
    }

    // Extract the first resource document
    final resourceDocument = resourceData.resourceDocument!.first;

    final fileName = resourceDocument.title ?? 'unknown.pdf';
    final pdfLanguage = widget.language;
    // try {
    // Find the download link matching the selected language
    final translation = (resourceDocument.resourceTranslations != null &&
            resourceDocument.resourceTranslations!.isNotEmpty)
        ? resourceDocument.resourceTranslations!.firstWhere(
            (element) => element.language == lang,
            orElse: () => resourceDocument.resourceTranslations!.first,
          )
        : null;

    final downloadLink = translation?.link ?? widget.pdfLink;
    if (downloadLink.isEmpty) {
      Utils.displayToast('no_document_for_language'.tr());
      return;
    }

    // Proceed with download

    Utils.displayToast('download_started'.tr());
    ref.read(downloadToolTipProvider.notifier).state = false;

    final downloadLanguageTrans = DownloadLanguageTranslation(
      id: translation?.id ?? "${DateTime.now().millisecondsSinceEpoch}",
      language: pdfLanguage ?? "",
      link: translation?.link ?? downloadLink,
    );
    print("downloadLanguageTrans: ${downloadLanguageTrans.toJson()}");
    await ref.read(downloadProvider.notifier).download(
          DownloadedFile(
            id: resourceData.id ?? '',
            title: resourceData.title ?? '',
            imageUrl: resourceData.image?.url ?? '',
            author: resourceData.author ?? '',
            description: resourceData.description ?? '',
            publishedAt: resourceData.publishingDate ?? '',
            fileName: fileName,
            fileUrl: downloadLink,
            pdfLanguage: pdfLanguage,
            downloadLanguageTranslations: [downloadLanguageTrans],
          ),
        );
    // } catch (e) {
    //   if (!mounted) return;
    //   Utils.displayToast('failed_to_download_pdf'.tr());
    // }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = context.locale;
    print("locale: $locale");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 40.w,
        automaticallyImplyLeading: false,
        leading: Container(
          padding: EdgeInsets.only(
              left: locale.languageCode == "en" ? 12.w : 2.0,
              right: locale.languageCode == "ar" ? 12.w : 2.0),
          child: GestureDetector(
            onTap: () => navigator.pop(context),
            child: SvgPicture.asset(AppImages.backIconConatiner),
          ),
        ),
        title: Text(
          'pdf_reader'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: AppColors.appGradientColors,
            ),
          ),
        ),
        actions: widget.isDownload == false
            ? [
                ShareFavoriteWidget(
                  onTap: () {
                    Share.share(
                      widget.pdfLink,
                      subject:
                          'This was shared with you from the BePrepared App [${widget.pdfLink}]',
                    );
                  },
                  svgImage: AppImages.shareIconSvg,
                ),
                SizedBox(width: 6.w),
                ShareFavoriteWidget(
                  onTap: () {
                    handleResourceDownload(
                      context,
                      resourceData: widget.resourceDetails,
                      lang: widget.language ?? '',
                    );
                  },
                  svgImage: AppImages.downloadSvg,
                ),
                SizedBox(width: 12.w),
              ]
            : [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loadError
              ? Center(child: Text('failed_to_load_pdf'.tr()))
              : pdfController != null
                  ? Stack(children: [
                      PdfView(
                        controller: pdfController!,
                        pageSnapping: true,
                        scrollDirection: Axis.vertical,
                        onDocumentLoaded: (document) {
                          print(
                              "PDF loaded with ${document.pagesCount} pages.");
                        },
                        onPageChanged: (page) {
                          print("Page changed to: $page");
                        },
                      ),
                      Visibility(
                        visible: ref.watch(downloadToolTipProvider) &&
                            widget.isDownload == false,
                        child: Positioned(
                          top: 8.h,
                          right: locale.languageCode == "en" ? 10.w : null,
                          left: locale.languageCode == "en" ? null : 10.w,
                          child: Container(
                            width: 270.w,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.appWhiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              border: Border.all(
                                color: AppColors.appBlueColor,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "download_resource_message".tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Image.asset(
                                  AppImages.handCursorpng,
                                  height: 30.h,
                                ),
                                // SvgPicture.asset(
                                //   AppImages.handCursor,
                                //   color: AppColors.appBlackColor,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ])
                  : const Center(child: Text('Failed to load PDF')),
    );
  }
}
