package com.developmentarc.framework.utils.logging
{
	public class ExternalInterfaceDebugLogger
	{
		public function ExternalInterfaceDebugLogger()
		{
		}
		
		public static function info(message:String, classReference:String = "", method:String = ""):void {
			if(DebugLogger.externalInterfaceEnabled) {
				DebugLogger.info(message, classReference, method, DebugMessage.SOURCE_JAVASCRIPT);
			}
		}
		public static function debug(message:String, classReference:String = "", method:String = ""):void {
			if(DebugLogger.externalInterfaceEnabled) {
				DebugLogger.debug(message, classReference, method, DebugMessage.SOURCE_JAVASCRIPT);
			}
		
		}
		public static function warn(message:String, classReference:String = "", method:String = ""):void {
			if(DebugLogger.externalInterfaceEnabled) {
				DebugLogger.warn(message, classReference, method, DebugMessage.SOURCE_JAVASCRIPT);
			}
		
		}
		public static function error(message:String, classReference:String = "", method:String = ""):void {
			if(DebugLogger.externalInterfaceEnabled) {
				DebugLogger.error(message, classReference, method, DebugMessage.SOURCE_JAVASCRIPT);
			}
		
		}
		public static function fatal(message:String, classReference:String = "", method:String = ""):void {
			if(DebugLogger.externalInterfaceEnabled) {
				DebugLogger.fatal(message, classReference, method, DebugMessage.SOURCE_JAVASCRIPT);
			}
		
		}
		
	}
}