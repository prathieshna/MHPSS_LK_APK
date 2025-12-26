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
    "https://ap-south-1.cdn.hygraph.com/content/cmj15y3p8012p07v0ba06afxr/master");

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);
