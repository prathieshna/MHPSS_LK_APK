class ResourcesQuery {
  static String getPopularResourcesQuery(String locale) {
    return """
      query Toolkit {
          toolkit(where: { slug: "mhpsslk-app" }) {
            description
            hostMessage
            id
            title
            resources(where: { language: $locale }) {
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

  static String searchResourcesQuery(String searchQuery, String locale) {
    return """
      query SearchResources {
        resources(
          where: {
            language: $locale
            OR: [
              { title_contains: "$searchQuery" }
              { author_contains: "$searchQuery" }
              { descriptionDeprecated_contains: "$searchQuery" }
              { tags_contains_some: ["$searchQuery"] }
            ]
          }
          first: 50
        ) {
          id
          title
          slug
          author
          descriptionDeprecated
          publishingDate
          publishedAt
          createdAt
          popular
          tags
          image {
            id
            url
          }
          resourceDocument {
            id
            fileFormat
          }
          toolkitCategories {
            id
            title
          }
        }
      }
    """;
  }

  static String getSingleResourceQuery(String? id, String locale) {
    print("qurey id: $id");
    return """
      query {
             resource(where: { id: "$id" }) {
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
                resourceTranslations(where: { language: $locale }) {
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
