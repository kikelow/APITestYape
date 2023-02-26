#language: en

  Feature: Creacion de booking

      Background:

        * url baseUrl

      Scenario: Creacion correcta de booking

        * def requestBooking =
      """
      {
        "firstname" : "#(firstname)",
        "lastname" : "#(lastname)",
        "totalprice" : '#(parseInt(totalprice))',
        "depositpaid" : #(depositpaid),
        "bookingdates" : {
        "checkin" : "#(checkin)",
        "checkout" : "#(checkout)"
        },
        "additionalneeds" : "#(additionalneeds)"
      }
      """

        * def responseExpected =
    """
        {
          "bookingid": #number,
          "booking": {
            "firstname": "#(firstname)",
            "lastname": "#(lastname)",
            "totalprice": '#(parseInt(totalprice))',
            "depositpaid": #(depositpaid),
            "bookingdates": {
                "checkin": "#(checkin)",
                "checkout": "#(checkout)"
            },
            "additionalneeds": "#(additionalneeds)"
          }
        }
    """

        Given path '/booking'
        And header Content-type = 'application/json'
        And header Accept = 'application/json'
        And request requestBooking
        When method post
        Then status 200
        And match response == responseExpected
