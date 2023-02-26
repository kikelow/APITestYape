#language: en

Feature: Autenticacion API

  Background:

    * url baseUrl

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
      | userName  | password        | responseAuth                 | testCase                           |
      | "admin"   | "password123"   | {"token" : "#string"}        | Credenciales correctas             |
      | "admin12" | "password123"   | {"reason":"Bad credentials"} | Usuario errado y password correcto |
      | "admin"   | "password12345" | {"reason":"Bad credentials"} | Usuario correcto y password errado |
      | "admin12" | "password12345" | {"reason":"Bad credentials"} | Usuario errado y password errado   |
      | ""        | ""              | {"reason":"Bad credentials"} | Usuario y password vacios          |
      | null      | null            | {"reason":"Bad credentials"} | Usuario y password nulos           |
      | "admin"   | ""              | {"reason":"Bad credentials"} | Credenciales correctas             |
      | ""        | "password12345" | {"reason":"Bad credentials"} | Credenciales correctas             |
      | null      | "password123"   | {"reason":"Bad credentials"} | Usuario nulo y password ingresado  |
      | "admin"   | null            | {"reason":"Bad credentials"} | Usuario ingresado y password nulo  |

