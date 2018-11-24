# AppGameKit_Logger
A logging script for AppGameKit2.

# 1. Usage
	1. Include "logger.agc" in your project by using command #include
	
	2. Use function "InitializeLogger" to initialize logger. For example:
		InitializeLogger(LOGGER_DEBUG, 1, "log.txt", 0)
	
	3. Start logging messages by provided shortcuts functions:
		- LogCritical(text As String)
		- LogError(text As String)
		- LogWarning(text As String)
		- LogInfo(text As String)
		- LogDebug(text As String)
		- LogTrace(text As String)
    
# 2. Log message format
Default format used is: `<CurrentDate> <CurrentTime> <LOG_LEVEL> <message>`
where

	- CurrentDate - output from the function CurrentDate()
	- CurrentTime - output from the function CurrentTime()
	- LOG_LEVEL - log message's log level as a string
	- message - the log message

Modify function "LogMessage" to change the log format.

# 3. Other information
You can change the log level while running by using function "SetLogLevel".

Currently console logging works only in Debug mode.
