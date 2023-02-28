#language: en

@Auth
Feature: Autenticacion API

  Background:

    * url baseUrl
    * def username = java.lang.System.getenv('AUTHORIZATION_USERNAME');
    * def password = java.lang.System.getenv('AUTHORIZATION_PASSWORD');


  Scenario Outline: Autenticacion con <testCase>

    * def requestAuth =
    """ {
    "username" : <userName>,
    "password" : <password>
    } """

    Given path 'auth'
    And header Content-Type = 'application/json'
    And request requestAuth
    When method post
    Then status 200
    And match response == <responseAuth>

    Examples:
      | userName    | password        | responseAuth                 | testCase                           |
      | #(username) | #(password)     | {"token" : "#string"}        | Credenciales correctas             |
      | "admin12"   | #(password)     | {"reason":"Bad credentials"} | Usuario errado y password correcto |
      | #(username) | "password12345" | {"reason":"Bad credentials"} | Usuario correcto y password errado |
      | "admin12"   | "password12345" | {"reason":"Bad credentials"} | Usuario errado y password errado   |
      | ""          | ""              | {"reason":"Bad credentials"} | Usuario y password vacios          |
      | null        | null            | {"reason":"Bad credentials"} | Usuario y password nulos           |
      | #(username) | ""              | {"reason":"Bad credentials"} | Usuario correcto y password vacio  |
      | ""          | #(password)     | {"reason":"Bad credentials"} | Usuario vacio y password correcto  |
      | null        | #(password)     | {"reason":"Bad credentials"} | Usuario nulo y password ingresado  |
      | #(username) | null            | {"reason":"Bad credentials"} | Usuario ingresado y password nulo  |

