/******************************************************************************

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>

******************************************************************************/

/******************************************************************************
logger.agc - A logging script for AppGameKit2

+----------+
| 1. USAGE |
+----------+

	a. Include "logger.agc" in your project by using command #include
	
	b. Use function "InitializeLogger" to initialize logger. For example:
		InitializeLogger(LOGGER_DEBUG, 1, "log.txt", 0)
	
	c. Start logging messages by provided shortcuts functions:
		- LogCritical(text As String)
		- LogError(text As String)
		- LogWarning(text As String)
		- LogInfo(text As String)
		- LogDebug(text As String)
		- LogTrace(text As String)

+-----------------------+
| 2. LOG MESSAGE FORMAT |
+-----------------------+
Default format used is: <CurrentDate()> <CurrentTime()> <LOG_LEVEL> <message>
where
	<CurrentDate()> is the output of function CurrentDate()
	<CurrentTime()> is the output of function CurrentTime()
	<LOG_LEVEL> is the log level as string
	<message> is the given message
	
Modify function "LogMessage" to change the log format.

+----------------------+
| 3. OTHER INFORMATION |
+----------------------+
You can change the log level while running by using function "SetLogLevel".

Currently console logging works only in Debug mode.

******************************************************************************/

// Constants for valid log levels
#constant LOGGER_OFF 		= 0
#constant LOGGER_CRITICAL	= 1
#constant LOGGER_ERROR	= 2
#constant LOGGER_WARNING	= 3
#constant LOGGER_INFO		= 4
#constant LOGGER_DEBUG	= 5
#constant LOGGER_TRACE	= 6

// Contains log level names in string format
Global LOGGER_LEVEL_TEXT As String[7]

// Current logging level
Global LOGGER_LOG_LEVEL As Integer = LOGGER_DEBUG

// File ID of logging file. Set to -1 to disable logging to file.
Global LOGGER_LOG_TO_FILE As Integer = -1

// Set to 1 to enable logging to console, 0 to disable.
Global LOGGER_LOG_TO_CONSOLE As Integer = 1

// ****************************************************************************
// FUNCTION: 		InitializeLogger
// DESCRIPTION:	Initialize logger.
// PARAMETERS:
//		log_level - Specify log level by using one of the defined constants:
//					LOGGER_OFF
//					LOGGER_CRITICAL
//					LOGGER_ERROR
//					LOGGER_WARNING
//					LOGGER_INFO
//					LOGGER_DEBUG
//					LOGGER_TRACE
//		console - Set to 1 to enable logging to console, 0 to disable. Please
//				 note that console logging works only when debugging.
// 		filename - Filename to use for logging. Set to "" to disable
//				  logging to file.
//		append - Set to 1 to append to the file, 0 to overwrite all data.
// ****************************************************************************
Function InitializeLogger(log_level As Integer, console As Integer, filename As String, append As Integer)
	LOGGER_LEVEL_TEXT[LOGGER_OFF]		= "OFF"
	LOGGER_LEVEL_TEXT[LOGGER_CRITICAL]	= "CRITICAL"
	LOGGER_LEVEL_TEXT[LOGGER_ERROR]	= "ERROR"
	LOGGER_LEVEL_TEXT[LOGGER_WARNING]	= "WARNING"
	LOGGER_LEVEL_TEXT[LOGGER_INFO]		= "INFO"
	LOGGER_LEVEL_TEXT[LOGGER_DEBUG]	= "DEBUG"
	LOGGER_LEVEL_TEXT[LOGGER_TRACE]	= "TRACE"

	If console = 0
		LOGGER_LOG_TO_CONSOLE = 0 // Logging to console disabled
	Else
		LOGGER_LOG_TO_CONSOLE = 1 // Logging to console enabled
	EndIf
	
	// Check if filename is specified
	If Len(filename) > 0
		LOGGER_LOG_TO_FILE = OpenToWrite(filename, append)
	Else
		LOGGER_LOG_TO_FILE = -1 // Logging to file disabled
	EndIf
	
	// Set log level
	SetLogLevel(log_level)
	
	LogMessage(LOGGER_INFO, "Logger initialized on level: " + LOGGER_LEVEL_TEXT[LOGGER_INFO])
	
	If LOGGER_LOG_TO_FILE > 0
		LogMessage(LOGGER_INFO, "Logging to file: " + GetWritePath() + filename)
	EndIf
EndFunction


// ****************************************************************************
// Shortcut functions to log message on different levels
// ****************************************************************************
Function LogCritical(text As String)
	LogMessage(LOGGER_CRITICAL, text)
EndFunction
Function LogError(text As String)
	LogMessage(LOGGER_ERROR, text)
EndFunction
Function LogWarning(text As String)
	LogMessage(LOGGER_WARNING, text)
EndFunction
Function LogInfo(text As String)
	LogMessage(LOGGER_INFO, text)
EndFunction
Function LogDebug(text As String)
	LogMessage(LOGGER_DEBUG, text)
EndFunction
Function LogTrace(text As String)
	LogMessage(LOGGER_TRACE, text)
EndFunction


// ****************************************************************************
// FUNCTION: 		LogMessage
// DESCRIPTION:	Log given message if given log level is within defined
//                logging level.
// PARAMETERS:
//		log_level - Specify log level of the message by using one of the
//                   defined constants:
//					LOGGER_OFF
//					LOGGER_CRITICAL
//					LOGGER_ERROR
//					LOGGER_WARNING
//					LOGGER_INFO
//					LOGGER_DEBUG
//					LOGGER_TRACE
//		text - Message to be logged
// ****************************************************************************
Function LogMessage(log_level As Integer, text as String)
	// Check that the specified log level is valid
	If log_level > LOGGER_LOG_LEVEL Or log_level < 0 Then ExitFunction
	
	// Add current date and time to log message
	msg As String = ""
	msg = msg + GetCurrentDate() + " " + GetCurrentTime() + " " + LOGGER_LEVEL_TEXT[log_level] + " " + text
	
	// Log to file
	If LOGGER_LOG_TO_FILE <> -1
		WriteLine(LOGGER_LOG_TO_FILE, msg)
	EndIf
	
	// Log to console
	If LOGGER_LOG_TO_CONSOLE <> -1
		Log(msg)
	EndIf
EndFunction


// ****************************************************************************
// FUNCTION: 		SetLogLevel
// DESCRIPTION:	Set log level.
// PARAMETERS:
//		log_level - Specify log level to be used by using one of the
//                   defined constants:
//					LOGGER_OFF
//					LOGGER_CRITICAL
//					LOGGER_ERROR
//					LOGGER_WARNING
//					LOGGER_INFO
//					LOGGER_DEBUG
//					LOGGER_TRACE
// ****************************************************************************
Function SetLogLevel(log_level As Integer)
	If log_level < 0 Or log_level > LOGGER_TRACE
		LogMessage(LOGGER_CRITICAL, "SetLogLevel(): Invalid log level defined: " + Str(log_level) + ". Defaulting to DEBUG")
		log_level = LOGGER_DEBUG
	EndIf

	Select log_level
		Case LOGGER_TRACE
			LOGGER_LOG_LEVEL = LOGGER_TRACE
		EndCase

		Case LOGGER_DEBUG
			LOGGER_LOG_LEVEL = LOGGER_DEBUG
		EndCase

		Case LOGGER_INFO
			LOGGER_LOG_LEVEL = LOGGER_INFO
		EndCase

		Case LOGGER_WARNING
			LOGGER_LOG_LEVEL = LOGGER_WARNING
		EndCase

		Case LOGGER_ERROR
			LOGGER_LOG_LEVEL = LOGGER_ERROR
		EndCase

		Case LOGGER_CRITICAL
			LOGGER_LOG_LEVEL = LOGGER_CRITICAL
		EndCase

		Case LOGGER_OFF
			LOGGER_LOG_LEVEL = LOGGER_OFF
		EndCase

		Case Default
			LogMessage(LOGGER_CRITICAL, "SetLogLevel(): Invalid log level defined: " + Str(log_level) + ". Defaulting to DEBUG")
			LOGGER_LOG_LEVEL = LOGGER_DEBUG
		EndCase
	EndSelect
EndFunction
