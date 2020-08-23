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
package net.sourceforge.plantuml;

import java.awt.geom.Dimension2D;
import java.awt.geom.Rectangle2D;

import net.sourceforge.plantuml.activitydiagram3.ftile.EntityImageLegend;
import net.sourceforge.plantuml.cucadiagram.Display;
import net.sourceforge.plantuml.cucadiagram.DisplayPositionned;
import net.sourceforge.plantuml.cucadiagram.DisplaySection;
import net.sourceforge.plantuml.graphic.FontConfiguration;
import net.sourceforge.plantuml.graphic.HorizontalAlignment;
import net.sourceforge.plantuml.graphic.HtmlColor;
import net.sourceforge.plantuml.graphic.HtmlColorUtils;
import net.sourceforge.plantuml.graphic.InnerStrategy;
import net.sourceforge.plantuml.graphic.StringBounder;
import net.sourceforge.plantuml.graphic.SymbolContext;
import net.sourceforge.plantuml.graphic.TextBlock;
import net.sourceforge.plantuml.graphic.TextBlockUtils;
import net.sourceforge.plantuml.graphic.USymbol;
import net.sourceforge.plantuml.svek.DecorateEntityImage;
import net.sourceforge.plantuml.svek.TextBlockBackcolored;
import net.sourceforge.plantuml.ugraphic.MinMax;
import net.sourceforge.plantuml.ugraphic.UGraphic;
import net.sourceforge.plantuml.ugraphic.UTranslate;

public class AnnotatedWorker {

	private final Annotated annotated;
	private final ISkinParam skinParam;
	private final StringBounder stringBounder;

	public AnnotatedWorker(Annotated annotated, ISkinParam skinParam, StringBounder stringBounder) {
		this.annotated = annotated;
		this.skinParam = skinParam;
		this.stringBounder = stringBounder;
	}

	public TextBlockBackcolored addAdd(TextBlock result) {
		result = addFrame(result);
		result = addLegend(result);
		result = addTitle(result);
		result = addCaption(result);
		result = addHeaderAndFooter(result);
		return (TextBlockBackcolored) result;
	}

	public TextBlock addFrame(final TextBlock original) {
		final Display mainFrame = annotated.getMainFrame();
		if (mainFrame == null) {
			return original;
		}

		final double x1 = 5;
		final double x2 = 7;
		final double y1 = 10;
		final double y2 = 10;

		final SymbolContext symbolContext = new SymbolContext(getSkinParam().getBackgroundColor(), HtmlColorUtils.BLACK)
				.withShadow(getSkinParam().shadowing(null));
		final TextBlock title = mainFrame.create(new FontConfiguration(getSkinParam(), FontParam.CAPTION, null),
				HorizontalAlignment.CENTER, getSkinParam());
		final Dimension2D dimTitle = title.calculateDimension(stringBounder);
		final Dimension2D dimOriginal = original.calculateDimension(stringBounder);
		final double width = x1 + Math.max(dimOriginal.getWidth(), dimTitle.getWidth()) + x2;
		final double height = dimTitle.getHeight() + y1 + dimOriginal.getHeight() + y2;
		final TextBlock result = USymbol.FRAME.asBig(title, HorizontalAlignment.LEFT, TextBlockUtils.empty(0, 0),
				width, height, symbolContext, skinParam.getStereotypeAlignment());

		return new TextBlockBackcolored() {

			public void drawU(UGraphic ug) {
				result.drawU(ug);
				original.drawU(ug.apply(new UTranslate(x1, y1 + dimTitle.getHeight())));
			}

			public MinMax getMinMax(StringBounder stringBounder) {
				return TextBlockUtils.getMinMax(result, stringBounder);
			}

			public Rectangle2D getInnerPosition(String member, StringBounder stringBounder, InnerStrategy strategy) {
				return result.getInnerPosition(member, stringBounder, strategy);
			}

			public Dimension2D calculateDimension(StringBounder stringBounder) {
				return result.calculateDimension(stringBounder);
			}

			public HtmlColor getBackcolor() {
				return symbolContext.getBackColor();
			}
		};
	}

	private TextBlock addLegend(TextBlock original) {
		final DisplayPositionned legend = annotated.getLegend();
		if (legend.isNull()) {
			return original;
		}
		final TextBlock text = EntityImageLegend.create(legend.getDisplay(), getSkinParam());

		return DecorateEntityImage.add(original, text, legend.getHorizontalAlignment(), legend.getVerticalAlignment());
	}

	private ISkinParam getSkinParam() {
		return skinParam;
	}

	private TextBlock addCaption(TextBlock original) {
		final DisplayPositionned caption = annotated.getCaption();
		if (caption.isNull()) {
			return original;
		}
		final TextBlock text = getCaption();

		return DecorateEntityImage.addBottom(original, text, HorizontalAlignment.CENTER);
	}

	public TextBlock getCaption() {
		final DisplayPositionned caption = annotated.getCaption();
		if (caption.isNull()) {
			return TextBlockUtils.empty(0, 0);
		}
		return caption.getDisplay().create(new FontConfiguration(getSkinParam(), FontParam.CAPTION, null),
				HorizontalAlignment.CENTER, getSkinParam());
	}

	private TextBlock addTitle(TextBlock original) {
		final DisplayPositionned title = annotated.getTitle();
		if (title.isNull()) {
			return original;
		}
		ISkinParam skinParam = getSkinParam();
		final FontConfiguration fontConfiguration = new FontConfiguration(skinParam, FontParam.TITLE, null);

		final TextBlock block = TextBlockUtils.title(fontConfiguration, title.getDisplay(), skinParam);
		return DecorateEntityImage.addTop(original, block, HorizontalAlignment.CENTER);
	}

	private TextBlock addHeaderAndFooter(TextBlock original) {
		final DisplaySection footer = annotated.getFooter();
		final DisplaySection header = annotated.getHeader();
		if (footer.isNull() && header.isNull()) {
			return original;
		}
		TextBlock textFooter = null;
		if (footer.isNull() == false) {
			textFooter = footer.createRibbon(new FontConfiguration(getSkinParam(), FontParam.FOOTER, null),
					getSkinParam());
		}
		TextBlock textHeader = null;
		if (header.isNull() == false) {
			textHeader = header.createRibbon(new FontConfiguration(getSkinParam(), FontParam.HEADER, null),
					getSkinParam());
		}

		return DecorateEntityImage.addTopAndBottom(original, textHeader, header.getHorizontalAlignment(), textFooter,
				footer.getHorizontalAlignment());
	}
}