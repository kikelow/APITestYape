#language: en

  Feature: Autenticar usuario

    Background:

      * url baseUrl

      Scenario: Obtencion de exitosa de token de autenticacion

        * def requestAuth =
          """ {
          "username" : '#(username)',
          "password" : '#(password)'
          } """

        Given path 'auth'
        And header Content-Type = 'application/json'
        And request requestAuth
        When method post
        Then status 200
        And match response == '#(responseAuth)'
