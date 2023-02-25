#language: en

Feature: Operaciones en API Booking

  Background:

    * url baseUrl

  Scenario Outline: Creacion exitosa de booking

    * def requestBooking =
      """
      {
        "firstname" : "<firstname>",
        "lastname" : "<lastname>",
        "totalprice" : <totalprice>,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    * def responseExpected =

    """
        {
          "bookingid": #number,
          "booking": {
            "firstname": "<firstname>",
            "lastname": "<lastname>",
            "totalprice": <totalprice>,
            "depositpaid": <depositpaid>,
            "bookingdates": {
                "checkin": "<checkin>",
                "checkout": "<checkout>"
            },
            "additionalneeds": "<additionalneeds>"
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

    * def idBooking = response.bookingid

    #Se realiza consulta por ID del booking recien creado

    Given path '/booking'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep {"bookingid": '#(idBooking)'}

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner          |

  Scenario Outline: Creacion de booking con objetos faltantes en el request

    * def requestBooking =
      """
      {
        "lastname" : "<lastname>",
        "totalprice" : <totalprice>,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    Given path '/booking'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    And request requestBooking
    When method post
    Then status 500
    And match response == 'Internal Server Error'

    Examples:

      | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner          |

  Scenario Outline: Consulta id de booking por ID de registro

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    * def responseExpected =

    """
        {
           "firstname":"<firstname>",
           "lastname":"<lastname>",
           "totalprice":<totalprice>,
           "depositpaid":<depositpaid>,
           "bookingdates":{
              "checkin":"<checkin>",
              "checkout":"<checkout>"
           },
           "additionalneeds":"<additionalneeds>"
        }
    """

    Given path '/booking/'+idBooking
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response == responseExpected

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking inexistente

    Given path '/booking/'+<idBooking>
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 404
    And match response == 'Not Found'

    Examples:

      | idBooking |
      | 999999999 |

  Scenario Outline: Consulta id de booking en formato string

    Given path '/booking/'+'<idBooking>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 404
    And match response == 'Not Found'

    Examples:

      | idBooking |
      | codigo |

  Scenario Outline: Consulta id de booking por filtro de nombre y apellido

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param firstname = '<firstname>'
    And param lastname = '<lastname>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep [{"bookingid":#(idBooking)}]

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de nombre unicamente

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param firstname = '<firstname>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep {"bookingid":#(idBooking)}

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de apellido unicamente

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param lastname = '<lastname>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep {"bookingid":#(idBooking)}

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de apellido y nombre con parametros vacios

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param firstname = ''
    And param lastname = ''
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response == '#[0]'

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de fecha de checkIn y fecha de checkOut

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param checkin = '<checkin>'
    And param checkout = '<checkout>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep {"bookingid": '#(idBooking)'}

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de fecha de checkIn

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param checkin = '<checkin>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep {"bookingid": '#(idBooking)'}

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de fecha de checkOut

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param checkout = '<checkout>'
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains deep {"bookingid": '#(idBooking)'}

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Consulta id de booking por filtro de fecha de vacios

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'
    And param checkin = ''
    And param checkout = ''
    And header Content-type = 'application/json'
    And header Accept = 'application/json'
    When method get
    Then status 500
    And match response == 'Internal Server Error'

    Examples:

      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
