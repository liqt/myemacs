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
 */
package net.sourceforge.plantuml.timingdiagram;

import net.sourceforge.plantuml.graphic.SymbolContext;
import net.sourceforge.plantuml.graphic.UDrawable;
import net.sourceforge.plantuml.ugraphic.UGraphic;
import net.sourceforge.plantuml.ugraphic.UPath;
import net.sourceforge.plantuml.ugraphic.UPolygon;

public class PentaAShape implements UDrawable {

	private final double width;
	private final double height;
	private final SymbolContext context;

	private final double delta = 12;

	private PentaAShape(double width, double height, SymbolContext context) {
		this.width = width;
		this.height = height;
		this.context = context;
	}

	public static PentaAShape create(double width, double height, SymbolContext context) {
		return new PentaAShape(width, height, context);
	}

	public void drawU(UGraphic ug) {
		final UPolygon polygon = new UPolygon();
		polygon.addPoint(0, 0);
		polygon.addPoint(width - delta, 0);
		polygon.addPoint(width, height / 2);
		polygon.addPoint(width - delta, height);
		polygon.addPoint(0, height);

		context.withForeColor(context.getBackColor()).apply(ug).draw(polygon);

		final UPath path = new UPath();
		path.moveTo(0, 0);
		path.lineTo(width - delta, 0);
		path.lineTo(width, height / 2);
		path.lineTo(width - delta, height);
		path.lineTo(0, height);

		context.apply(ug).draw(path);

	}

}
