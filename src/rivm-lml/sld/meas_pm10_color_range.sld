<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>measurements_pm10</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>RIVM measurements PM10</Title>
            <Abstract>RIVM measurements_pm10 style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!--
                            "201 - MAX PM10": {
                                "upper" : 10000.0,
                                "lower" : 200.0,
                                "color" : "#5A0000"
                            },
                            "151 - 200 PM10": {
                                "upper" : 200.0,
                                "lower" : 150.0,
                                "color" : "#C00000"
                            },
                            "101 - 150 PM10": {
                                "upper" : 150.0,
                                "lower" : 100.0,
                                "color" : "#FF0000"
                            },
                            "71 - 100 PM10": {
                                "upper" : 100.0,
                                "lower" : 70.0,
                                "color" : "#FF8000"
                            },
                            "51 - 70 PM10": {
                                "upper" : 70.0,
                                "lower" : 50.0,
                                "color" : "#F8E748"
                            },
                            "41 - 50 PM10": {
                                "upper" : 50.0,
                                "lower" : 40.0,
                                "color" : "#CCFF33"
                            },
                            "31 - 40 PM10": {
                                "upper" : 40.0,
                                "lower" : 30.0,
                                "color" : "#00FF00"
                            },
                            "21 - 30 PM10": {
                                "upper" : 30.0,
                                "lower" : 20.0,
                                "color" : "#009800"
                            },
                            "11 - 20 PM10": {
                                "upper" : 20.0,
                                "lower" : 10.0,
                                "color" : "#007EFD"
                            },
                            "0 - 10 PM10": {
                                "upper" : 10.0,
                                "lower" : 0.0,
                                "color" : "#0000FF"
                             }
                        }
                        -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>0 - 10 ug/m3</Name>
                    <Title>  0 - 10 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsLessThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>10.5</ogc:Literal>
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
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>11 - 20 ug/m3</Name>
                    <Title>  11 - 20 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>10.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>20.5</ogc:Literal>
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
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>21 - 30 ug/m3</Name>
                    <Title>  21 - 30 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>20.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>30.5</ogc:Literal>
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
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>31 - 40 ug/m3</Name>
                    <Title>  31 - 40 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>30.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>40.5</ogc:Literal>
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
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>41 - 50 ug/m3</Name>
                    <Title>  41 - 50 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>40.5</ogc:Literal>
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
                                    <CssParameter name="fill">#CCFF33</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>51 - 70 ug/m3</Name>
                    <Title>  51 - 70 ug/m3</Title>
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
                                    <CssParameter name="fill">#F8E748</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>71 - 100 ug/m3</Name>
                    <Title>  71 - 100 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>70.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>100.5</ogc:Literal>
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
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>101 - 150 ug/m3</Name>
                    <Title>  101 - 150 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>100.5</ogc:Literal>
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
                                    <CssParameter name="fill">#FF0000</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
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
                                    <CssParameter name="fill">#C00000</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>201 - MAX ug/m3</Name>
                    <Title>  &gt; 201 ug/m3</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsGreaterThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>200.5</ogc:Literal>
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
                                    <CssParameter name="stroke">#3f3f3f</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <!--<Name>Sample Value</Name>-->
                    <!--<Title>  Sample Values in ug/m3</Title>-->
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
