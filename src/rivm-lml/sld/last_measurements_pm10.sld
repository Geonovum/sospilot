<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>Measurements PM10</Name>
        <Name>Measurements PM10 ug/m3</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>Smart Emission measurements PM10</Title>
            <Abstract>Smart Emission measurements_pm10 style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
             <!--
       <sld:ColorMapEntry color="#FFFFFF" label="Fijn Stof (µg pm10/m³)" opacity="0.01" quantity="-1"/>
       <sld:ColorMapEntry color="#FFFFFF" label="kaart ververst elk uur" opacity="0.01" quantity="0"/>
       <sld:ColorMapEntry color="#0020C5" label="0-5          Goed" opacity="1.0" quantity="5"/>
       <sld:ColorMapEntry color="#002BF7" label="5-10        Goed" opacity="1.0" quantity="10"/>
       <sld:ColorMapEntry color="#006DF8" label="10-15      Goed" opacity="1.0" quantity="15"/>
       <sld:ColorMapEntry color="#009CF9" label="15-20      Goed" opacity="1.0" quantity="20"/>
       <sld:ColorMapEntry color="#2DCDFB" label="20-25      Goed" opacity="1.0" quantity="25"/>
       <sld:ColorMapEntry color="#C4ECFD" label="25-30      Goed" opacity="1.0" quantity="30"/>
       <sld:ColorMapEntry color="#FFFED0" label="30-39      Matig" opacity="1.0" quantity="39"/>
       <sld:ColorMapEntry color="#FFFDA4" label="39-48      Matig" opacity="1.0" quantity="48"/>
       <sld:ColorMapEntry color="#FFFD7B" label="48-57      Matig" opacity="1.0" quantity="57"/>
       <sld:ColorMapEntry color="#FFFC4D" label="57-66      Matig" opacity="1.0" quantity="66"/>
       <sld:ColorMapEntry color="#F4E645" label="66-75      Matig" opacity="1.0" quantity="75"/>
       <sld:ColorMapEntry color="#FFB255" label="75-93      Onvoldoende" opacity="1.0" quantity="92.5"/>
       <sld:ColorMapEntry color="#FF9845" label="93-110    Onvoldoende" opacity="1.0" quantity="110"/>
       <sld:ColorMapEntry color="#FE7626" label="110-125  Onvoldoende" opacity="1.0" quantity="125"/>
       <sld:ColorMapEntry color="#FF0A17" label="125-150  Slecht" opacity="1.0" quantity="150"/>
       <sld:ColorMapEntry color="#DC0610" label="150-200  Slecht" opacity="1.0" quantity="200"/>
       <sld:ColorMapEntry color="#A21794" label="> 200      Zeer slecht" opacity="1.0" quantity="999"/>
        -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>0 - 5 ug/m3</Name>
                    <Title>  0 - 5 Goed</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsLessThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>5</ogc:Literal>
                        </ogc:PropertyIsLessThan>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#0020C5</CssParameter>
                                    <CssParameter name="fill-opacity">1.0</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>5 - 10 ug/m3</Name>
                    <Title>  5 - 10 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>4.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>10</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                   <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#002BF7</CssParameter>
                                    <CssParameter name="fill-opacity">1.0</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>10 - 15 ug/m3</Name>
                    <Title>  10 - 15 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>9.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>15</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#006DF8</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>15 - 20 ug/m3</Name>
                    <Title>  15 - 20 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>14.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>20</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#009CF9</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>20 - 25 ug/m3</Name>
                    <Title>  20 - 25 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>19.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>25</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#2DCDFB</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>25 - 30 ug/m3</Name>
                    <Title>  25 - 30 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>24.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>30</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#C4ECFD</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>30 - 39  ug/m3</Name>
                    <Title>  30 - 39  Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>29.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>39</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FFFED0</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>39-48 ug/m3</Name>
                    <Title>  39 - 48 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>38.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>48</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FFFDA4</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#EEEEEE</CssParameter>
                                    <CssParameter name="stroke-width">2</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>48 - 57 ug/m3</Name>
                    <Title>  48 - 57 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>47.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>57</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FFFD7B</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>57-66 ug/m3</Name>
                    <Title>  57 - 66 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>56.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>66</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FFFC4D</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>66-75 ug/m3</Name>
                    <Title>  66 - 75 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>65.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>75</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#F4E645</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>75-93 ug/m3</Name>
                    <Title>  75 - 93 Onvoldoende</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>74.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>93</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FFB255</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>93-110 ug/m3</Name>
                    <Title>  93 - 110 Onvoldoende</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>92.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>110</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FF9845</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>110-125 ug/m3</Name>
                    <Title>  110 - 125 Onvoldoende</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>109.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>125</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FE7626</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>125-150 ug/m3</Name>
                    <Title>  125 - 150 Slecht</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>124.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>150</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FF0A17</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>150-200 ug/m3</Name>
                    <Title>  150 - 200 Slecht</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>149.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>200</ogc:Literal>
                            </ogc:PropertyIsLessThan>
                        </ogc:And>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#DC0610</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>200 - MAX ug/m3</Name>
                    <Title>  &gt; 200 Zeer slecht</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsGreaterThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>199.5</ogc:Literal>
                        </ogc:PropertyIsGreaterThan>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#A21794</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#EEEEEE</CssParameter>
                                     <CssParameter name="stroke-width">2</CssParameter>
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
                                <ogc:Literal>SansSerif</ogc:Literal>
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
                            <CssParameter name="fill">#666666</CssParameter>
                        </Fill>

                    </TextSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
