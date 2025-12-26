class PagesQuery {
  static String pagesQuery(String locale) {
    return '''
      query MyQuery {
        pagesConnection(where: { language: $locale }, last: 10, stage: PUBLISHED) {
          edges {
            node {
              title
              summary
              language
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
                onboardingScreens(where: { language: $locale }) {
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
