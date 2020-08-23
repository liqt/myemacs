/* ========================================================================
 * PlantUML : a free UML diagram generator
 * ========================================================================
 *
 * (C) Copyright 2009-2020, Arnaud Roques
 *
 * Project Info:  http://plantuml.com
 * 
 * If you like this project or if you find it useful, you can support us at:
 * 
 * http://plantuml.com/patreon (only 1$ per month!)
 * http://plantuml.com/paypal
 * 
 * This file is part of PlantUML.
 *
 * PlantUML is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PlantUML distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
 * License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
 * USA.
 *
 *
 * Original Author:  Arnaud Roques
 * 
 *
 */
package net.sourceforge.plantuml.preproc2;

import java.io.IOException;
import java.util.List;

import net.sourceforge.plantuml.StringLocated;
import net.sourceforge.plantuml.preproc.DefinesGet;
import net.sourceforge.plantuml.preproc.ReadLine;
import net.sourceforge.plantuml.preproc.ReadLineList;

public class PreprocessorDefineApply implements ReadFilter {

	private final DefinesGet defines;

	public PreprocessorDefineApply(DefinesGet defines) throws IOException {
		this.defines = defines;
	}

	public ReadLine applyFilter(final ReadLine source) {
		return new Inner(source);
	}

	class Inner extends ReadLineInsertable {

		final ReadLine source;

		Inner(ReadLine source) {
			this.source = source;
		}

		@Override
		void closeInternal() throws IOException {
			source.close();
		}

		@Override
		StringLocated readLineInternal() throws IOException {
			final StringLocated s = this.source.readLine();
			if (s == null || s.getPreprocessorError() != null) {
				return s;
			}
			if (PreprocessorDefineLearner.isLearningLine(s)) {
				return s;
			}
			final List<String> result = defines.get().applyDefines(s.getString());
			if (result.size() > 1) {
				insert(new ReadLineList(result, s.getLocation()));
				return readLine();
			}
			String tmp = result.get(0);
			return new StringLocated(tmp, s.getLocation(), s.getPreprocessorError());
		}

	}

}