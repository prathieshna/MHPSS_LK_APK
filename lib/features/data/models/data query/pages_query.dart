class PagesQuery {
  static String pagesQuery(String locale) {
    return '''
      query MyQuery(\$locales: [Locale!] = $locale) {
        pagesConnection(locales: \$locales, last: 10, stage: PUBLISHED) {
          edges {
            node {
              title
              summary
              content {
                html
              }
            }
          }
        }
      }
    ''';
  }

  static String onboardingQuery(String locale) {
    return '''
          query onboardingScreens {
                onboardingScreens(where: { language: "$locale" }) {
                  title
                  language
                  description
                  image {
                    url
                  }
                }
              }
    ''';
  }
}
