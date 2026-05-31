{
  "openapi": "3.0.1",
  "info": {
    "title": "vault-contact-me",
    "version": "1.0"
  },
  "paths": {
    "/comments": {
      "get": {
          "responses": {
            "200": {
              "description": "OK",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/definitions/Comment"
                  }
                }
              }
            }
          },
          "x-amazon-apigateway-integration": {
            "httpMethod": "POST",
            "type": "aws_proxy",
            "passthroughBehavior": "WHEN_NO_MATCH",
            "payloadFormatVersion": "1.0",
            "uri": "${get_comments_lambda_uri}"
          }
      },
      "post": {
          "consumes": ["application/json"],
          "produces": ["application/json"],
          "parameters": [
            {
              "in": "body",
              "name": "Comments",
              "required": "true",
              "schema": {
                "$ref": "#/definitions/Comments"
              }
            }
          ],
          "responses": {
            "200": {
              "description": "OK",
              "content": {
                "text/plain": {
                  "schema": {
                    "type": "string",
                    "example": "pong"
                  }
                }
              }
            }
          },
          "x-amazon-apigateway-integration": {
            "httpMethod": "POST",
            "type": "aws_proxy",
            "passthroughBehavior": "WHEN_NO_MATCH",
            "payloadFormatVersion": "1.0",
            "uri": "${post_comments_lambda_uri}",
            "responses": {
              "default": {
                "statusCode": "200"
              }
            }
          }
      }
    },
    "/contacts": {
      "post": {
          "consumes": ["application/json"],
          "produces": ["application/json"],
          "parameters": [
            {
              "in": "body",
              "name": "Message",
              "required": "true",
              "schema": {
                "$ref": "#/definitions/Message"
              }
            }
          ],
          "responses": {
            "200": {
              "description": "OK",
              "content": {
                "text/plain": {
                  "schema": {
                    "type": "string",
                    "example": "pong"
                  }
                }
              }
            }
          },
          "x-amazon-apigateway-integration": {
            "httpMethod": "POST",
            "type": "aws_proxy",
            "passthroughBehavior": "WHEN_NO_MATCH",
            "payloadFormatVersion": "1.0",
            "uri": "${test_lambda_uri}",
            "responses": {
              "default": {
                "statusCode": "200"
              }
            }
          }
      }
    }
  },
  "definitions": {
    "Comment": {
      "type": "array",
      "items":{
        "type": "object",
        "properties": {
          "created_at": { "type": "string" },                    
          "username": { "type": "string"},                    
          "profile_url": {"type": "string"},                    
          "message": {"type": "string"}                    
        }
      }
    },
    "Message": {
      "type": "object",
      "properties": {
        "firstName": {"type": "string"},
        "lastName": {"type": "string"},
        "email": {"type": "string"},
        "subject": {"type": "string"},
        "message": {"type": "string"}
      }
    }
  }
}