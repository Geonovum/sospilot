<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>Measurements O3</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>Smart Emission measurements O3</Title>
            <Abstract>Smart Emission measurements_03 style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!--
           	"360 - MAX O3": {
            		"upper" : 10000.0,
            		"lower" : 360.0,
            		"color" : "#5A0000"
            	},
            	"240 - 360 O3": {
            		"upper" : 360.0,
            		"lower" : 240.0,
            		"color" : "#C00000"
            	},
            	"201 - 270 O3": {
            		"upper" : 240.0,
            		"lower" : 180.0,
            		"color" : "#FF0000"
            	},
            	"145 - 180 O3": {
            		"upper" : 180.0,
            		"lower" : 145.0,
            		"color" : "#FF8000"
            	},
            	"110 - 145 O3": {
            		"upper" : 145.0,
            		"lower" : 110.0,
            		"color" : "#F8E748"
            	},
            	"90 - 110 O3": {
            		"upper" : 110.0,
            		"lower" : 90.0,
            		"color" : "#CCFF33"
            	},
            	"70 - 90 O3": {
            		"upper" : 90.0,
            		"lower" : 70.0,
            		"color" : "#00FF00"
            	},
            	"50 - 70 O3": {
            		"upper" : 70.0,
            		"lower" : 50.0,
            		"color" : "#009800"
            	},
            	"30 - 50 O3": {
            		"upper" : 50.0,
            		"lower" : 30.0,
            		"color" : "#007EFD"
            	},
            	"0 - 30 O3": {
            		"upper" : 30.0,
            		"lower" : 0.0,
            		"color" : "#0000FF"
             	}                     -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>0 - 30 ug/m3</Name>
                    <Title>  0 - 30 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsLessThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>30.5</ogc:Literal>
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
                    <Name>31 - 51 ug/m3</Name>
                    <Title>  31 - 51 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>30.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>50.5</ogc:Literal>
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
                    <Name>51 - 71 ug/m3</Name>
                    <Title>  51 - 71 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>50.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>70.5</ogc:Literal>
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
                    <Name>71 - 90 ug/m3</Name>
                    <Title>  71 - 90 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>70.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>90.5</ogc:Literal>
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
                    <Name>91 - 110 ug/m3</Name>
                    <Title>  91 - 110 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>90.5</ogc:Literal>
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
                    <Name>111 - 145   ug/m3</Name>
                    <Title>  111 - 145   ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>110.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>145.5</ogc:Literal>
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
                    <Name>146 - 180 ug/m3</Name>
                    <Title>  146 - 180 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>145.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>180.5</ogc:Literal>
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
                    <Name>181 - 240 ug/m3</Name>
                    <Title>  181 - 240  ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>180.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>240.5</ogc:Literal>
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
                    <Name>241 - 360 ug/m3</Name>
                    <Title>  241 - 360 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>240.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>360.5</ogc:Literal>
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
                    <Name>360 - MAX ug/m3</Name>
                    <Title>  &gt; 360 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsGreaterThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>360.5</ogc:Literal>
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
                            <CssParameter name="fill">#ffffff</CssParameter>
                        </Fill>

                    </TextSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
