class ResourcesQuery {
  static String getPopularResourcesQuery(String locale) {
    return """
      query Toolkit {
          toolkit(locales: $locale, where: { slug: "mhpsslk-app" }) {
            description
            hostMessage
            id
            title
            resources {
              id
              image { url }
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
              toolkitCategories {
                id
                longTitle
                slug
                tags
                title
              }
              popular
            }
          }
        }
    """;
  }

  static String getSingleResourceQuery(String? id, String locale) {
    print("qurey id: $id");
    return """
      query {
             resource(where: { id: "$id" }, locales: $locale) {
            accessToMaterials
            author
            dataType
            description
            descriptionDeprecated
            id
            order
            publishedAt
            publishingDate
            slug
            stage
            tags
            title
            updatedAt
            resourceDocument {
                id
                link
                title
                resourceTranslations(locales: $locale) {
                    createdAt
                    id
                    language
                    link
                    publishedAt
                    stage
                    updatedAt
                }
                fileFormat
            }
            resourceCategory
            image {
                id
                url
            }
            toolkitCategories {
            id 
           }
        }
      }
    """;
  }
}
