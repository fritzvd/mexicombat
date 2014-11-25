package ::APP_PACKAGE::;

import android.os.Bundle;
import android.util.Log;

public class MainActivity extends org.haxe.lime.GameActivity {
    private static final String TAG = "MyActivity";

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);

   }

    @Override
    protected void onStart() {
        super.onStart();
        cb.onStart(this);
    }

    @Override
    protected void onStop() {
        super.onStop();

        cb.onStop(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        cb.onDestroy(this);
    }

    @Override
    public void onBackPressed() {

        if (cb.onBackPressed())
            return;
        else
            super.onBackPressed();
    }

    public static void showLink() {
    }
}

