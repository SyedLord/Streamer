package com.syedlord.streamer

import android.app.AlertDialog
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.OpenableColumns
import android.widget.Toast // 🌟 Yahan Native Toast ka import lagaya hai
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yourapp/file_picker"
    private val DIALOG_CHANNEL = "com.syedlord.streamer/dialog"
    private val PICK_VIDEO_REQUEST = 101
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ─── File Picker Channel ───────────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickVideoUri" -> {
                        pendingResult = result
                        openVideoPicker()
                    }
                    "getFileSize" -> {
                        val uriString = call.argument<String>("uri")
                        if (uriString != null) {
                            result.success(getFileSize(uriString))
                        } else {
                            result.error("INVALID_URI", "URI was null", null)
                        }
                    }
                    "getFileName" -> {
                        val uriString = call.argument<String>("uri")
                        if (uriString != null) {
                            result.success(getFileName(uriString))
                        } else {
                            result.error("INVALID_URI", "URI was null", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ─── Dialog Channel ────────────────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DIALOG_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    // ✅ OK + Cancel wala — returns true/false
                    "showNativeDialog" -> {
                        val title = call.argument<String>("title") ?: ""
                        val message = call.argument<String>("message") ?: ""
                        val confirmText = call.argument<String>("confirmText") ?: "Confirm"
                        val cancelText = call.argument<String>("cancelText") ?: "Cancel"
                        showNativeDialog(title, message, confirmText, cancelText, result)
                    }

                    // ✅ Sirf OK wala — sirf information ke liye
                    "showNativeAlert" -> {
                        val title = call.argument<String>("title") ?: ""
                        val message = call.argument<String>("message") ?: ""
                        val okText = call.argument<String>("okText") ?: "OK"
                        showNativeAlert(title, message, okText, result)
                    }

                    // 🌟 NAYA: Native OS Toast
                    "showNativeToast" -> {
                        val message = call.argument<String>("message") ?: ""
                        val isLong = call.argument<Boolean>("isLong") ?: false
                        showNativeToast(message, isLong, result)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // ─── Native Toast Function ─────────────────────────────────────────────
    private fun showNativeToast(
        message: String,
        isLong: Boolean,
        result: MethodChannel.Result
    ) {
        runOnUiThread {
            // Android ko automatically faisla karne dega OS styling ka
            val duration = if (isLong) Toast.LENGTH_LONG else Toast.LENGTH_SHORT
            Toast.makeText(this, message, duration).show()
            result.success(null)
        }
    }

    // ─── OK + Cancel Dialog ────────────────────────────────────────────────
    private fun showNativeDialog(
        title: String,
        message: String,
        confirmText: String,
        cancelText: String,
        result: MethodChannel.Result
    ) {
        runOnUiThread {
            // 🌟 Original Default Behavior
            AlertDialog.Builder(this, android.R.style.Theme_DeviceDefault_Dialog_Alert)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(confirmText) { dialog, _ ->
                    dialog.dismiss()
                    result.success(true)
                }
                .setNegativeButton(cancelText) { dialog, _ ->
                    dialog.dismiss()
                    result.success(false)
                }
                .setCancelable(false)
                .show()
        }
    }

    // ─── Sirf OK Alert ─────────────────────────────────────────────────────
    private fun showNativeAlert(
        title: String,
        message: String,
        okText: String,
        result: MethodChannel.Result
    ) {
        runOnUiThread {
            // 🌟 Original Default Behavior
            AlertDialog.Builder(this, android.R.style.Theme_DeviceDefault_Dialog_Alert)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(okText) { dialog, _ ->
                    dialog.dismiss()
                    result.success(null)
                }
                .setCancelable(false)
                .show()
        }
    }

    // ─── Video Picker ──────────────────────────────────────────────────────
    private fun openVideoPicker() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "video/*"
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        }
        startActivityForResult(intent, PICK_VIDEO_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_VIDEO_REQUEST) {
            if (resultCode == RESULT_OK && data?.data != null) {
                val uri = data.data!!
                contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
                pendingResult?.success(uri.toString())
            } else {
                pendingResult?.success(null)
            }
            pendingResult = null
        }
    }

    // ─── File Helpers ──────────────────────────────────────────────────────
    private fun getFileSize(uriString: String): Long {
        return try {
            val uri = Uri.parse(uriString)
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                val sizeIndex = cursor.getColumnIndex(OpenableColumns.SIZE)
                cursor.moveToFirst()
                cursor.getLong(sizeIndex)
            } ?: -1L
        } catch (e: Exception) {
            -1L
        }
    }

    private fun getFileName(uriString: String): String? {
        return try {
            val uri = Uri.parse(uriString)
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                cursor.moveToFirst()
                cursor.getString(nameIndex)
            }
        } catch (e: Exception) {
            null
        }
    }
}