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
      | codigo    |

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

    * def resultCreateBooking = call  read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }

    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking'
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

  Scenario Outline: Actualizacion completa exitosa de booking con cookie

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token

    * def requestUpdateBooking =
      """
      {
        "firstname" : "<newfirstname>",
        "lastname" : "<newlastname>",
        "totalprice" : <newtotalprice>,
        "depositpaid" : <newdepositpaid>,
        "bookingdates" : {
        "checkin" : "<newcheckin>",
        "checkout" : "<newcheckout>"
        },
        "additionalneeds" : "<newadditionalneeds>"
      }
      """

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token='+tokenAuth
    And request requestUpdateBooking
    When method put
    Then status 200
    And match response == requestUpdateBooking

    Examples:

      | username | password    | responseAuth          | newfirstname | newlastname | newtotalprice | newdepositpaid | newcheckin | newcheckout | newadditionalneeds | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | Harlen       | Renteria    | 600000        | true           | 2023-03-10 | 2023-03-30  | Sabanas  extras    | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion completa exitosa de booking con header de Autorizacion

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking =
      """
      {
        "firstname" : "<newfirstname>",
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

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method put
    Then status 200
    And match response == requestUpdateBooking

    Examples:

      | autorization             | responseAuth          | newfirstname | newlastname | newtotalprice | newdepositpaid | newcheckin | newcheckout | newadditionalneeds | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Harlen       | Renteria    | 600000        | true           | 2023-03-10 | 2023-03-30  | Sabanas  extras    | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion completa de booking con valor string en campo de totalprice

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking =
      """
      {
        "firstname" : "<firstname>",
        "lastname" : "<lastname>",
        "totalprice" : <newtotalprice>,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    * def resposeUpdateBookingExpected =
      """
      {
        "firstname" : "<firstname>",
        "lastname" : "<lastname>",
        "totalprice" : #null,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method put
    Then status 200
    And match response == resposeUpdateBookingExpected

    Examples:

      | autorization             | responseAuth          | newtotalprice | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | abcd          | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion completa de booking con valor string (cadena de texto) en el query param ID

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking =
      """
      {
        "firstname" : "<firstname>",
        "lastname" : "<lastname>",
        "totalprice" : <newtotalprice>,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    * def resposeUpdateBookingExpected =
      """
      {
        "firstname" : "<firstname>",
        "lastname" : "<lastname>",
        "totalprice" : #null,
        "depositpaid" : <depositpaid>,
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    Given path '/booking/'+'abcd'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method put
    Then status 405
    And match response == 'Method Not Allowed'

    Examples:

      | autorization             | responseAuth          | newtotalprice | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | abcd          | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion completa de booking con camppos faltantes en el request

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking =
      """
      {
        "firstname" : "<newfirstname>",
        "lastname" : "<lastname>",
        "bookingdates" : {
        "checkin" : "<checkin>",
        "checkout" : "<checkout>"
        },
        "additionalneeds" : "<additionalneeds>"
      }
      """

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method put
    Then status 400
    And match response == 'Bad Request'

    Examples:

      | autorization             | responseAuth          | newfirstname | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Harlen       | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion completa de booking sin id de booking

    * def requestUpdateBooking =
      """
      {
        "firstname" : "<newfirstname>",
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
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method put
    Then status 404
    And match response == 'Not Found'

    Examples:

      | autorization             | responseAuth          | newfirstname | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Harlen       | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Actualizacion parcial exitosa de booking con header de Autorizacion

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking = <requestUpdateBooking>

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method patch
    Then status 200
    And match response contains deep <responseUpdateBookingExpected>

    Examples:

      | autorization             | responseAuth          | responseUpdateBookingExpected                | requestUpdateBooking                     | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"firstname" : "Harlen"}                     | {"firstname" : "Harlen"}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"lastname" : "Rodriguez"}                   | {"lastname" : "Rodriguez"}               | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"totalprice" : 5000000}                     | {"totalprice" : 5000000}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"depositpaid" : true}                       | {"depositpaid" : true}                   | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"bookingdates":{"checkin" : "2023-03-01"}}  | {"bookingdates.checkin" : "2023-03-01"}  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"bookingdates":{"checkout" : "2023-03-15"}} | {"bookingdates.checkout" : "2023-03-15"} | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | {"additionalneeds" : "Almuerzo"}             | {"additionalneeds" : "Almuerzo"}         | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Actualizacion parcial exitosa de booking con cookie

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token

    * def requestUpdateBooking = <requestUpdateBooking>

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token='+tokenAuth
    And request requestUpdateBooking
    When method patch
    Then status 200
    And match response contains deep <responseUpdateBookingExpected>

    Examples:

      | username | password    | responseAuth          | responseUpdateBookingExpected                | requestUpdateBooking                     | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | {"firstname" : "Harlen"}                     | {"firstname" : "Harlen"}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"lastname" : "Rodriguez"}                   | {"lastname" : "Rodriguez"}               | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"totalprice" : 5000000}                     | {"totalprice" : 5000000}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"depositpaid" : true}                       | {"depositpaid" : true}                   | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"bookingdates":{"checkin" : "2023-03-01"}}  | {"bookingdates.checkin" : "2023-03-01"}  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"bookingdates":{"checkout" : "2023-03-15"}} | {"bookingdates.checkout" : "2023-03-15"} | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"additionalneeds" : "Almuerzo"}             | {"additionalneeds" : "Almuerzo"}         | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Actualizacion parcial exitosa de booking con auth cookie y campos vacios

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token

    * def requestUpdateBooking = <requestUpdateBooking>

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token='+tokenAuth
    And request requestUpdateBooking
    When method patch
    Then status 200
    And match response contains deep <responseUpdateBookingExpected>

    Examples:

      | username | password    | responseAuth          | responseUpdateBookingExpected                | requestUpdateBooking           | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | {"firstname" : ""}                           | {"firstname" : ""}             | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"lastname" : ""}                            | {"lastname" : ""}              | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"bookingdates":{"checkin" : "0NaN-aN-aN"}}  | {"bookingdates.checkin" : ""}  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"bookingdates":{"checkout" : "0NaN-aN-aN"}} | {"bookingdates.checkout" : ""} | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"additionalneeds" : ""}                     | {"additionalneeds" : ""}       | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Actualizacion parcial exitosa de booking con auth cookie y campos con formato contrario

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token

    * def requestUpdateBooking = <requestUpdateBooking>

    Given path '/booking/'+idBooking
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token='+tokenAuth
    And request requestUpdateBooking
    When method patch
    Then status 200
    And match response contains deep <responseUpdateBookingExpected>

    Examples:

      | username | password    | responseAuth          | responseUpdateBookingExpected             | requestUpdateBooking                 | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | {"firstname" : "#null"}                   | {"firstname" : 4545}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"lastname" : "#null"}                    | {"lastname" : 7897}                  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"totalprice" : #null}                    | {"totalprice" : "valor"}             | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"depositpaid" : true}                    | {"depositpaid" : true}               | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"bookingdates":{"checkin" : "#string"}}  | {"bookingdates.checkin" : 20230301}  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"bookingdates":{"checkout" : "#string"}} | {"bookingdates.checkout" : 20230315} | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | admin    | password123 | {"token" : "#string"} | {"additionalneeds" : "#null"}             | {"additionalneeds" : 12345}          | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion parcial de booking con ID string

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking = <requestUpdateBooking>

    Given path '/booking/'+'idBooking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method patch
    Then status 405
    And match response == '<responseUpdateBookingExpected>'

    Examples:

      | autorization             | responseAuth          | responseUpdateBookingExpected | requestUpdateBooking                     | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"firstname" : "Harlen"}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"lastname" : "Rodriguez"}               | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"totalprice" : 5000000}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"depositpaid" : true}                   | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"bookingdates.checkin" : "2023-03-01"}  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"bookingdates.checkout" : "2023-03-15"} | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Method Not Allowed            | {"additionalneeds" : "Almuerzo"}         | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |

  Scenario Outline: Actualizacion parcial de booking con ID vacio

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def requestUpdateBooking = <requestUpdateBooking>

    Given path '/booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Authorization = 'Basic '+'<autorization>'
    And request requestUpdateBooking
    When method patch
    Then status 404
    And match response == '<responseUpdateBookingExpected>'

    Examples:

      | autorization             | responseAuth          | responseUpdateBookingExpected | requestUpdateBooking                     | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"firstname" : "Harlen"}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"lastname" : "Rodriguez"}               | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"totalprice" : 5000000}                 | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"depositpaid" : true}                   | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"bookingdates.checkin" : "2023-03-01"}  | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"bookingdates.checkout" : "2023-03-15"} | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Not Found                     | {"additionalneeds" : "Almuerzo"}         | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Eliminacion exitosa de booking con Auth cookie

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token


    Given path '/booking/'+idBooking
    And header Cookie = 'token='+tokenAuth
    When method delete
    Then status 201
    And match response == 'Created'

    Examples:
      | username | password    | responseAuth          | newfirstname | newlastname | newtotalprice | newdepositpaid | newcheckin | newcheckout | newadditionalneeds | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | Harlen       | Renteria    | 600000        | true           | 2023-03-10 | 2023-03-30  | Sabanas  extras    | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Eliminacion exitosa de booking con header Authorization

    * def resultCreateBooking = call read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    Given path '/booking/'+idBooking
    And header Authorization = 'Basic '+'<autorization>'
    When method delete
    Then status 201
    And match response == 'Created'

    Examples:
      | autorization             | responseAuth          | newfirstname | newlastname | newtotalprice | newdepositpaid | newcheckin | newcheckout | newadditionalneeds | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | YWRtaW46cGFzc3dvcmQxMjM= | {"token" : "#string"} | Harlen       | Renteria    | 600000        | true           | 2023-03-10 | 2023-03-30  | Sabanas  extras    | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Eliminacion de booking id en formato string

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token

    Given path '/booking/'+'idBooking'
    And header Cookie = 'token='+tokenAuth
    When method delete
    Then status 405
    And match response == 'Method Not Allowed'

    Examples:
      | username | password    | responseAuth          | newfirstname | newlastname | newtotalprice | newdepositpaid | newcheckin | newcheckout | newadditionalneeds | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | Harlen       | Renteria    | 600000        | true           | 2023-03-10 | 2023-03-30  | Sabanas  extras    | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |


  Scenario Outline: Eliminacion de booking id vacio

    * def resultCreateBooking = callonce read('../common/CreateBooking.feature'){ baseUrl: '#(baseUrl)', depositpaid : <depositpaid>  }
    * def idBooking = resultCreateBooking.response.bookingid

    * def resultGetTokenAuth = callonce read('../common/GetTokenAutentication.feature'){ baseUrl: '#(baseUrl)' , responseAuth : <responseAuth> }
    * def tokenAuth = resultGetTokenAuth.response.token

    Given path '/booking'
    And header Cookie = 'token='+tokenAuth
    When method delete
    Then status 404
    And match response == 'Not Found'

    Examples:
      | username | password    | responseAuth          | newfirstname | newlastname | newtotalprice | newdepositpaid | newcheckin | newcheckout | newadditionalneeds | firstname | lastname | totalprice | depositpaid | checkin    | checkout   | additionalneeds |
      | admin    | password123 | {"token" : "#string"} | Harlen       | Renteria    | 600000        | true           | 2023-03-10 | 2023-03-30  | Sabanas  extras    | Harinson  | Palacios | 1000       | false       | 2023-02-15 | 2023-02-25 | dinner2         |
