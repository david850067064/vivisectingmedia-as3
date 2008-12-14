package com.vivisectingmedia.libtests.elements.tasks
{
	import com.vivisectingmedia.framework.controllers.abstracts.AbstractTask;

	public class TestTaskPriority4 extends TestTask
	{
		public static const TYPE:String = "Priority_four";
		public static const PRIORITY:int = 4;
		
		public function TestTaskPriority4(type:String="", priority:int=5)
		{
			super(TestTaskPriority4.TYPE, TestTaskPriority4.PRIORITY);
		}	
		
	}
}