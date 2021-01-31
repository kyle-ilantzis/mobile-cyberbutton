package com.kyleilantzis.cyberbtn

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Path
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.AttributeSet
import android.util.TypedValue
import android.view.*
import kotlinx.android.synthetic.main.activity_main.*

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

    val isGlitch: Boolean
    var clipPath = Path()

    init {
        context.theme.obtainStyledAttributes(attrSet, R.styleable.CyberButton,  0, 0).apply {
            try {
                isGlitch = getBoolean(R.styleable.CyberButton_isGlitch, false)
            }
            finally {
                recycle()
            }
        }

        if (isGlitch) {
            val oneDip = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 1.0F, resources.displayMetrics)
            setShadowLayer(oneDip, oneDip*2, oneDip*2, resources.getColor(R.color.cyBlue))
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        clipPath = createMaskPath(measuredWidth, measuredHeight)
    }

    override fun draw(canvas: Canvas?) {
        canvas?.clipPath(clipPath)
        super.draw(canvas)
    }

    override fun onDraw(canvas: Canvas?) {
        if (!isGlitch) {
            super.onDraw(canvas)
            return
        }

        val oneDip = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 1.0F, resources.displayMetrics)

        setShadowLayer(0.25F, oneDip*2, oneDip*2, resources.getColor(R.color.cyBlue))
        super.onDraw(canvas)

        setShadowLayer(0.25F, -oneDip*2, -oneDip*2, resources.getColor(R.color.cyYellow10))
        super.onDraw(canvas)
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