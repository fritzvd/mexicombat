package ::APP_PACKAGE::;

import android.os.Bundle;
import com.chartboost.sdk.*;

public class MainActivity extends org.haxe.nme.GameActivity {
    private Chartboost cb;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);

        this.cb = Chartboost.sharedChartboost();
        String appId = "5293a10f2d42da233155865a";
        String appSignature = "85eeca8926d9aac88b466edece67899b9c8795ed";
        this.cb.onCreate(this, appId, appSignature, null);

        this.cb.startSession();
        this.cb.showInterstitial();
        // this.cb.cacheInterstitial();
    }

    @Override
    protected void onStart() {
        super.onStart();
        this.cb.onStart(this);
    }

    @Override
    protected void onStop() {
        super.onStop();

        this.cb.onStop(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        this.cb.onDestroy(this);
    }

    @Override
    public void onBackPressed() {

        if (this.cb.onBackPressed())
            return;
        else
            super.onBackPressed();
    }

    public void showChartboost() {
        this.cb.showInterstitial();
    }
}

