package com.vivisectingmedia.libtests.elements.tasks
{
	import com.vivisectingmedia.framework.controllers.abstracts.AbstractTask;

	public class TestTaskPriority2 extends TestTask
	{
		public static const TYPE:String = "Priority_two";
		public static const PRIORITY:int = 2;
		
		public function TestTaskPriority2(type:String="", priority:int=5)
		{
			super(TestTaskPriority2.TYPE, TestTaskPriority2.PRIORITY);
		}		
	}
}