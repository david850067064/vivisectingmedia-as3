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
 * The Original Code is Flex 3 TestUtils version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.flexunit
{
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * The TestUtils class is a helper utility designed for developing FlexUnit
	 * testing suites.  The methods on the utility are static and are intendend
	 * to speed up development and similify management of tests suites.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class TestUtils
	{
		/**
		 * This method provides an automated way to generate TestSuites from a
		 * TestCase Class that follows the "test" prefix naming standard. The method
		 * uses the type description of the provided Class to determine the public
		 * methods that are avaliable.  The method then searches for all methods
		 * that start with "test", all lower case, and assumes this is a valid
		 * test method for the TestCase. A new TestCase is generated the class instance
		 * passing in the found method as a test method.  This TestCase is then added
		 * to the Suite which is handed back to the caller once all the TestCases have
		 * been found and generated.
		 * 
		 * @param classReference TestCase Class to generate a TestSuite from.
		 * @return The generated TestSuite with all the "test" methods appended.
		 * 
		 */
		static public function generateFullSuite(classReference:Class):TestSuite
		{
			var suite:TestSuite = new TestSuite();
			
			// pull all the public functions that start with test
			var self:XML = describeType(classReference);
			var methods:XMLList = self.factory.method;
			for each(var method:XML in methods)
			{
				var name:String = method.@name;
				if(name.indexOf("test") == 0)
				{
					suite.addTest(new classReference(name));
				}
			}
			
			return suite;
		}
	}
}