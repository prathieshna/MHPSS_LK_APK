import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String graphqlQuery = """
      query Posts{
        posts{
          id
          publishedAt
          title
          excerpt
          coverImage {
            url
          }
          author {
            id
            name
          }
        }
      }
      """;

final HttpLink httpLink = HttpLink(
    "https://ap-south-1.cdn.hygraph.com/content/cm4j9qqks07va07tf6j8msb0g/master");

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);
