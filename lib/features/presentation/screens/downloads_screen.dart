import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final downloadedFiles = ref.watch(downloadProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        isRemoveBottom: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            downloadedFiles.isEmpty
                ? Center(child: Text("no_downloads".tr()))
                : Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      itemCount: downloadedFiles.length,
                      itemBuilder: (context, index) {
                        final file = downloadedFiles[index];
                        // print(
                        //     "File path:--------- ${file.filePath}, File URL: ${file.fileUrl}, File name: ${file.fileName}");
                        return ResourceCard(
                          title: file.fileName ?? "",
                          description: file.description ?? "",
                          author: file.author ?? "",

                          publishedDate: file.publishedAt ?? "",
                          imageUrl: file.imageUrl ?? "",
                          pdfDocument: file.pdfDocument,
                          audioDocument: file.audioDocument,
                          videoDocument: file.videoDocumeent,
                          tags: ['MHPSS', 'MHPSS and EIE toolkit'],
                          languages: file.downloadLanguageTranslations
                                  ?.map((translation) => {
                                        'language': translation.language,
                                        'link': translation.link,
                                        'filePath': translation.filePath ?? ""
                                      })
                                  .toList() ??
                              [],

                          onLanguageTap: (pdfLink, filePath) {
                            print("pdfLink: $pdfLink");
                            print("filePath: ${file.filePath ?? ""}");
                            navigator.navigateTo(PdfReaderScreen(
                              pdfLink: pdfLink,
                              isDownload: true,
                              filePath: filePath ?? "",
                            ));
                          },
                          // languages: file.downloadLanguageTranslations
                          //         ?.map((translation) => translation.language)
                          //         .toList() ??
                          //     [],
                          hasVideo: false,
                          isDownloadedScreen: true,
                          onTap: () {
                            print("condition out");

                            if (file.downloadLanguageTranslations != null &&
                                file.downloadLanguageTranslations!.isNotEmpty) {
                              print("condition in");
                              final firstPdfLink =
                                  file.downloadLanguageTranslations!.first;
                              navigator.navigateTo(PdfReaderScreen(
                                pdfLink: firstPdfLink.link ?? "",
                                isDownload: true,
                                filePath: firstPdfLink.filePath ?? "",
                              ));
                            } else {
                              navigator.navigateTo(PdfReaderScreen(
                                pdfLink: file.fileUrl ?? "",
                                isDownload: true,
                                filePath: file.filePath ?? "",
                              ));
                            }
                          },
                          deleteTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text('delete_resource_title'.tr()),
                                      content: Text(
                                          'delete_resource_confirmation'.tr()),
                                      actions: [
                                        GestureDetector(
                                          child: Text('cancel'.tr()),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        SizedBox(width: 10.w),
                                        GestureDetector(
                                          child: Text(
                                            'delete'.tr(),
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onTap: () {
                                            ref
                                                .read(downloadProvider.notifier)
                                                .deleteFile(index);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ]);
                                });
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
