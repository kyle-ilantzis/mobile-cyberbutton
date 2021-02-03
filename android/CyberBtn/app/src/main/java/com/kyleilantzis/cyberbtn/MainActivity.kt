package com.kyleilantzis.cyberbtn

import android.animation.*
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Path
import android.graphics.drawable.AnimatedVectorDrawable
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.AttributeSet
import android.util.Log
import android.util.TypedValue
import android.view.*
import android.widget.FrameLayout
import androidx.core.animation.addListener
import androidx.core.graphics.PathParser
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

    val kMaskPathInset = dp(10.0F)
    val kInsetHorizontal = dp(40.0F)

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
            val oneDip = dp(1.0F)
            setShadowLayer(oneDip, oneDip*2, oneDip*2, resources.getColor(R.color.cyBlue))
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)

        if (!isGlitch) {
            clipPath = createMaskPath(measuredWidth, measuredHeight)
        }

        if (isGlitch) {
            val clipKeyframes = PropertyValuesHolder.ofKeyframe("",
                Keyframe.ofObject(0*1.0F/6.0F, createGlitchMaskPath1(measuredWidth, measuredHeight)),
                Keyframe.ofObject(1*1.0F/6.0F, createGlitchMaskPath2(measuredWidth, measuredHeight)),
                Keyframe.ofObject(2*1.0F/6.0F, createGlitchMaskPath3(measuredWidth, measuredHeight)),
                Keyframe.ofObject(3*1.0F/6.0F, createGlitchMaskPath2(measuredWidth, measuredHeight)),
                Keyframe.ofObject(3.3F*1.0F/6.0F, createMaskPath(measuredWidth, measuredHeight)),
                Keyframe.ofObject(4*1.0F/6.0F, createGlitchMaskPath2(measuredWidth, measuredHeight))
            ).apply {
                setEvaluator { fraction, startValue, endValue -> if (fraction <= 0.5) startValue else endValue }
            }

            val animClipPath = ObjectAnimator.ofPropertyValuesHolder(this, clipKeyframes).apply {
                duration = 300
                addUpdateListener {
                    clipPath = it.animatedValue as Path
                    postInvalidateOnAnimation()
                }
            }

            val posXKeyframes = PropertyValuesHolder.ofKeyframe("translationX",
                    Keyframe.ofFloat(0.0F, -4.0F),
                    Keyframe.ofFloat(0.33F, -8.0F),
                    Keyframe.ofFloat(0.66F, -4.0F)
            )

            val animPosX = ObjectAnimator.ofPropertyValuesHolder(this, posXKeyframes).apply {
                duration = 300
                addListener(onStart = { this@CyberButton.translationY = -4.0F })
            }

            isAnimForward = true
            anim = AnimatorSet().apply {
                addListener(onEnd = { onAnimEnd() })
                playTogether(animClipPath, animPosX)
                start()
            }
        }
    }

    var isAnimForward: Boolean = true
    var anim: AnimatorSet? = null

    fun onAnimEnd() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (isAnimForward) {
                isAnimForward = false
                anim?.reverse()
                return
            }
        }

        clipPath = Path()
        postInvalidate()

        isAnimForward = true
        Handler(Looper.getMainLooper()).postDelayed({
            anim?.start()
        }, 2000)

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

        val oneDip = dp(1.0F)

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

    private fun createGlitchMaskPath1(mw: Int, mh: Int): Path {
        val width = mw.toFloat() + kMaskPathInset
        val height = mh.toFloat() + kMaskPathInset

        val path = Path()
        path.moveTo(-kMaskPathInset, height - kInsetHorizontal*2/3)
        path.lineTo(width, height - kInsetHorizontal*2/3)
        path.lineTo(width, height)
        path.lineTo(kMaskPathInset + kInsetHorizontal*2/3, height)
        path.lineTo(-kMaskPathInset, height - kInsetHorizontal*2/3)

        return path
    }

    private fun createGlitchMaskPath2(mw: Int, mh: Int): Path {
        val width = mw.toFloat() + kMaskPathInset
        val center = mh.toFloat()/2
        val visibleTextHeight = dp(4.0F)

        val path = Path()
        path.moveTo(-kMaskPathInset, center - visibleTextHeight)
        path.lineTo(width, center - visibleTextHeight)
        path.lineTo(width, center + visibleTextHeight)
        path.lineTo(-kMaskPathInset, center + visibleTextHeight)
        path.lineTo(-kMaskPathInset, center - visibleTextHeight)
        return path
    }

    private fun createGlitchMaskPath3(mw: Int, mh: Int): Path {
        val width = mw.toFloat() + kMaskPathInset
        val height = mh.toFloat() + kMaskPathInset
        val center = mh.toFloat() - kInsetHorizontal

        val path = Path()
        path.moveTo(-kMaskPathInset, center)
        path.lineTo(width, center)
        path.lineTo(width, height)
        path.lineTo(kMaskPathInset + kInsetHorizontal*2/3, height)
        path.lineTo(-kMaskPathInset, height - kInsetHorizontal*3/3)
        path.lineTo(-kMaskPathInset, center)
        return path
    }

    private fun dp(value: Float): Float {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, resources.displayMetrics)
    }
}