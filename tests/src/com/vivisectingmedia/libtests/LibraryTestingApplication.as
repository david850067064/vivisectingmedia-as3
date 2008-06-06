/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Flex 3 LibraryTestingApplication version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests
{
	import com.vivisectingmedia.libtests.tests.EventBrokerTests;
	import com.vivisectingmedia.libtests.tests.HashTableTests;
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
			
			suite.addTest( EventBrokerTests.suite() );
			suite.addTest( SelectionControllerTests.suite() );
			suite.addTest( HashTableTests.suite() );
			
			return suite;
		}
		
	}
}