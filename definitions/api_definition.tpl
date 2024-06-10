{
  "openapi": "3.0.1",
  "info": {
    "title": "vault-contact-me",
    "version": "1.0"
  },
  "paths": {
    "/path1": {
      "get": {
        "x-amazon-apigateway-integration": {
          "httpMethod": "GET",
          "type": "HTTP_PROXY",
          "payloadFormatVersion": "1.0",
          "uri": "https://ip-ranges.amazonaws.com/ip-ranges.json"
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
          "uri": "${lambda_uri}",
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