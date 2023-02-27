package booking.test;

import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

public class BookingRunner {

    @Karate.Test
    Karate testBooking(){
        return Karate.run("BookingOperations").tags("@Booking").relativeTo(getClass());
    }

    @Karate.Test
    Karate testAuth(){
        return Karate.run("Authentications").tags("@Auth").relativeTo(getClass());
    }

    @Karate.Test
    Karate testCheckHealth(){
        return Karate.run("CheckHealth").tags("@CheckHealth").relativeTo(getClass());
    }


}
