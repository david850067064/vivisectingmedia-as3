/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2008 James Polanco
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * ***** END MIT LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests
{
	import com.vivisectingmedia.flexunit.TestUtils;
	import com.vivisectingmedia.libtests.tests.EventBrokerTests;
	import com.vivisectingmedia.libtests.tests.HashTableTests;
	import com.vivisectingmedia.libtests.tests.QueueTests;
	import com.vivisectingmedia.libtests.tests.SelectionControllerTests;
	
	import flexunit.flexui.TestRunnerBase;
	import flexunit.framework.TestSuite;
	
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class LibraryTestingApplication extends Application
	{
		[Bindable]
		public var test_runner:TestRunnerBase;
		
		public function LibraryTestingApplication()
		{
			super();
			
			// register self events
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
		}
		
		protected function handleCreationComplete(event:FlexEvent):void
		{
			test_runner.test = createSuite();
			test_runner.startTest();
		}
		
		protected function createSuite():TestSuite
		{
			var suite:TestSuite = new TestSuite();
			
			// current test suites
			
			//*
			suite.addTest( TestUtils.generateFullSuite(EventBrokerTests) );
			suite.addTest( TestUtils.generateFullSuite(SelectionControllerTests) );
			suite.addTest( TestUtils.generateFullSuite(HashTableTests) );
			suite.addTest( TestUtils.generateFullSuite(QueueTests) );
			//*/
			
			
			return suite;
		}
		
	}
}