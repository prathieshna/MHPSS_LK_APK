class ToolkitQuery {
  static String toolkitCategoryQuery(String locale) {
    return """
      query {
        toolkit(where: { slug: "mhpsslk-app" }) {
                version
                toolkitCategories(where: { language: $locale }) {
                    id
                    title
                    slug
                    image {
                        id
                        url
                    }
                }
            }
      }
    """;
  }

  static String toolkitSubCategoryQuery(String locale) {
    return """
      query MyQuery @cached {
        toolkit(where: { slug: "mhpsslk-app" }) {
          toolkitCategories(where: { id: "cm4i632gzx8vh07uob77cxy3w", language: $locale }) {
            id
            title
            slug
            image {
              caption
              id
              locale
              url
            }
            toolkitSubCategories(where: { language: $locale }) {
              id
              slug
              title
              image {
                id
                url
              }
            }
          }
        }
      }
    """;
  }

  static String resourcesByCategoryQuery(String id, String locale) {
    return """
        query Toolkit {
            toolkit(where: { slug: "mhpsslk-app" }) {
                toolkitCategories(where: { id: "$id", language: $locale }) {
                    resource(where: { language: $locale }) {
                        id
                        image {
                            url
                        }
                        title
                        slug
                        publishingDate
                        publishedAt
                        createdAt
                        author
                        descriptionDeprecated
                        resourceDocument {
                            resourceTranslations {
                                id
                                language
                            }
                            fileFormat
                        }
                    }
                }
            }
        }
    """;
  }

  static String homePageVideoQuery(String locale) {
    return """
      query MyQuery {
        videos(where: { language: $locale }, last: 1) {
          title
          videoUrl
          language
        }
      }
    """;
  }
}
