package ::APP_PACKAGE::;

import android.os.Bundle;
import com.chartboost.sdk.*;

public class MainActivity extends org.haxe.nme.GameActivity {
    public static Chartboost cb;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);

        cb = Chartboost.sharedChartboost();
        String appId = "5293a10f2d42da233155865a";
        String appSignature = "85eeca8926d9aac88b466edece67899b9c8795ed";
        cb.onCreate(this, appId, appSignature, null);

        cb.startSession();
        // this.cb.showInterstitial();
        cb.cacheInterstitial();
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

    public static void showChartboost() {
        cb.showInterstitial();
    }
}

