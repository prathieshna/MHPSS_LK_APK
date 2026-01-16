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
              language
              resourceDocument {
                id
                link
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
            link
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
    print("query id: $id");
    // First, we need to get the resource to find its slug
    // Then we can query all resources with that slug
    // For now, keeping simple - will handle in UI layer
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
          language
          resourceDocument {
            id
            link
            title
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

  // New query to get all resources by slug (for translations)
  static String getResourcesBySlugQuery(String slug) {
    return """
      query {
        resources(where: { slug: "$slug" }) {
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
          language
          resourceDocument {
            id
            link
            title
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
