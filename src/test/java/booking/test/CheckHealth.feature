#language: en
  @CheckHealth
  Feature: Verificar estado de Booking API

    Background:
    * url baseUrl

    Scenario: Llamado get a para verificar estado de boking API
      Given path '/ping'
      When method get
      Then status 201
      And match response == 'Created'



