class ToolkitQuery {
  static String toolkitCategoryQuery(String locale) {
    return """
      query {
        toolkit(locales: $locale, where: { slug: "mhpsslk-app" }) {
                version
                toolkitCategories {
                    id
                    title
                    slug
                    image {
                        caption
                        id
                        locale
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
        toolkit(locales: $locale, where: { slug: "mhpsslk-app" }) {
          toolkitCategories(where: { id: "cm4i632gzx8vh07uob77cxy3w" }) {
            id
            title
            slug
            image {
              caption
              id
              locale
              url
            }
            toolkitSubCategories {
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
            toolkit(locales: $locale, where: { slug: "mhpsslk-app" }) {
                toolkitCategories(where: { id: "$id" }) {
                    resource {
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

  static String homePageVideoQuery() {
    return """
      query MyQuery {
        videos(last: 1) {
          title
          videoUrl
        }
      }
    """;
  }
}
