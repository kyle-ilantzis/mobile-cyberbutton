package com.kyleilantzis.cyberbtn

import android.content.Context
import android.graphics.Canvas
import android.graphics.Path
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.AttributeSet
import android.util.TypedValue
import android.view.*

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_IMMERSIVE
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_FULLSCREEN)
        setContentView(R.layout.activity_main)
    }
}



class CyberButton(ctx: Context, attrSet: AttributeSet): androidx.appcompat.widget.AppCompatButton(ctx, attrSet) {

    val kMaskPathInset = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 10.0F, resources.displayMetrics)
    val kInsetHorizontal = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 40.0F, resources.displayMetrics)

    var clipPath = Path()

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        clipPath = createMaskPath(measuredWidth, measuredHeight)
    }

    override fun draw(canvas: Canvas?) {
        canvas?.clipPath(clipPath)
        super.draw(canvas)
    }

    private fun createMaskPath(mw: Int, mh: Int): Path {
        val width = mw.toFloat() + kMaskPathInset
        val height = mh.toFloat() + kMaskPathInset

        val path = Path()
        path.moveTo(-kMaskPathInset, -kMaskPathInset)
        path.lineTo(width, -kMaskPathInset)
        path.lineTo(width, height)
        path.lineTo(kMaskPathInset + kInsetHorizontal*2/3, height)
        path.lineTo(-kMaskPathInset, height - kInsetHorizontal*3/3)
        path.lineTo(-kMaskPathInset, -kMaskPathInset)

        return path
    }
}