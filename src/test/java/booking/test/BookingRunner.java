package booking.test;

import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

public class BookingRunner {

    @Karate.Test
    Karate testBooking(){
        return Karate.run("CheckHealth").relativeTo(getClass());
    }

}
