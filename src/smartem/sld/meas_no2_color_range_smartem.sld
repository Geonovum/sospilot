<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>Measurements NO2</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>Smart Emission measurements NO2</Title>
            <Abstract>Smart Emission measurements_no2 style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!--
            	"401 - MAX NO2": {
            		"upper" : 10000.0,
            		"lower" : 400.0,
            		"color" : "#5A0000"
            	},
            	"271 - 400 NO2": {
            		"upper" : 400.0,
            		"lower" : 270.0,
            		"color" : "#C00000"
            	},
            	"201 - 270 NO2": {
            		"upper" : 270.0,
            		"lower" : 200.0,
            		"color" : "#FF0000"
            	},
            	"151 - 200 NO2": {
            		"upper" : 200.0,
            		"lower" : 150.0,
            		"color" : "#FF8000"
            	},
            	"111 - 150 NO2": {
            		"upper" : 150.0,
            		"lower" : 110.0,
            		"color" : "#F8E748"
            	},
            	"81 - 110 NO2": {
            		"upper" : 110.0,
            		"lower" : 80.0,
            		"color" : "#CCFF33"
            	},
            	"61 - 80 NO2": {
            		"upper" : 80.0,
            		"lower" : 60.0,
            		"color" : "#00FF00"
            	},
            	"46 - 60 NO2": {
            		"upper" : 60.0,
            		"lower" : 45.0,
            		"color" : "#009800"
            	},
            	"26 - 45 NO2": {
            		"upper" : 45.0,
            		"lower" : 25.0,
            		"color" : "#007EFD"
            	},
            	"0 - 25 NO2": {
            		"upper" : 25.0,
            		"lower" : 0.0,
            		"color" : "#0000FF"
             	}                       -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>0 - 25 ug/m3</Name>
                    <Title>  0 - 25 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsLessThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>25.5</ogc:Literal>
                        </ogc:PropertyIsLessThan>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#0000FF</CssParameter>
                                    <CssParameter name="fill-opacity">1.0</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>26 - 45 ug/m3</Name>
                    <Title>  26 - 45 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>25.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>45.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#007EFD</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>46 - 60 ug/m3</Name>
                    <Title>  46 - 60 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>45.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>60.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#009800</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>61 - 80 ug/m3</Name>
                    <Title>  61 - 80 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>60.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>80.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#00FF00</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>81 - 110 ug/m3</Name>
                    <Title>  81 - 110 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>80.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>110.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#CCFF33</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>111 - 150  ug/m3</Name>
                    <Title>  111 - 150  ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>110.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>150.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#F8E748</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>151 - 200 ug/m3</Name>
                    <Title>  151 - 200 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>150.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>200.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FF8000</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#FF0066</CssParameter>
                                    <CssParameter name="stroke-width">3</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>201 - 270 ug/m3</Name>
                    <Title>  201 - 270 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>200.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>270.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FF0000</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>271 - 400 ug/m3</Name>
                    <Title>  271 - 400 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>270.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>400.5</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#C00000</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>401 - MAX ug/m3</Name>
                    <Title>  &gt; 401 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsGreaterThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>400.5</ogc:Literal>
                        </ogc:PropertyIsGreaterThan>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#5A0000</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">3</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <!--<Name>Sample Value</Name>-->
                    <!--<Title>  Sample Value ug/m3</Title>-->

                    <TextSymbolizer>
                        <Label>
                            <ogc:Function name="numberFormat">
                                <ogc:Literal>##</ogc:Literal>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                            </ogc:Function>
                        </Label>

                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Lucida Sans Regular</ogc:Literal>
                            </CssParameter>

                            <CssParameter name="font-size">
                                <ogc:Literal>10</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>bold</ogc:Literal>
                            </CssParameter>
                        </Font>
                        <LabelPlacement>
                            <PointPlacement>
                                <AnchorPoint>
                                    <AnchorPointX>0.5</AnchorPointX>
                                    <AnchorPointY>0.5</AnchorPointY>
                                </AnchorPoint>
                            </PointPlacement>
                        </LabelPlacement>

                        <Fill>
                            <CssParameter name="fill">#FFCCFF</CssParameter>
                        </Fill>

                    </TextSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
