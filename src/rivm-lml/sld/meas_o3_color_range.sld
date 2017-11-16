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
            <Abstract>Smart Emission measurements_o3 style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!--  RIVM Colormap
       <sld:ColorMapEntry color="#FFFFFF" label="Ozon (µg/m³)" opacity="0.01" quantity="-1"/>
       <sld:ColorMapEntry color="#FFFFFF" label="kaart ververst elk uur" opacity="0.01" quantity="0"/>
       <sld:ColorMapEntry color="#0020C5" label="0-8          Goed" opacity="1.0" quantity="7.5"/>
       <sld:ColorMapEntry color="#002BF7" label="8-15        Goed" opacity="1.0" quantity="15"/>
       <sld:ColorMapEntry color="#006DF8" label="15-23      Goed" opacity="1.0" quantity="22.5"/>
       <sld:ColorMapEntry color="#009CF9" label="23-30      Goed" opacity="1.0" quantity="30"/>
       <sld:ColorMapEntry color="#2DCDFB" label="30-35      Goed" opacity="1.0" quantity="35"/>
       <sld:ColorMapEntry color="#C4ECFD" label="35-40      Goed" opacity="1.0" quantity="40"/>
       <sld:ColorMapEntry color="#FFFED0" label="40-52      Matig" opacity="1.0" quantity="52"/>
       <sld:ColorMapEntry color="#FFFDA4" label="52-64      Matig" opacity="1.0" quantity="64"/>
       <sld:ColorMapEntry color="#FFFD7B" label="64-76      Matig" opacity="1.0" quantity="76"/>
       <sld:ColorMapEntry color="#FFFC4D" label="76-88      Matig" opacity="1.0" quantity="88"/>
       <sld:ColorMapEntry color="#F4E645" label="88-100    Matig" opacity="1.0" quantity="100"/>
       <sld:ColorMapEntry color="#FFB255" label="100-128  Onvoldoende" opacity="1.0" quantity="128"/>
       <sld:ColorMapEntry color="#FF9845" label="128-156  Onvoldoende" opacity="1.0" quantity="156"/>
       <sld:ColorMapEntry color="#FE7626" label="156-180  Onvoldoende" opacity="1.0" quantity="180"/>
       <sld:ColorMapEntry color="#FF0A17" label="180-200  Slecht" opacity="1.0" quantity="200"/>
       <sld:ColorMapEntry color="#DC0610" label="200-240  Slecht" opacity="1.0" quantity="240"/>
       <sld:ColorMapEntry color="#A21794" label="> 240      Zeer slecht" opacity="1.0" quantity="999"/>
         -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>0 - 8 ug/m3</Name>
                    <Title>  0 - 8 Goed</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsLessThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>8</ogc:Literal>
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
                    <Name>8 - 15 ug/m3</Name>
                    <Title>  8 - 15 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>7.5</ogc:Literal>
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
                    <Name>15 - 23 ug/m3</Name>
                    <Title>  15 - 23 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>14.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>23</ogc:Literal>
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
                    <Name>23 - 30 ug/m3</Name>
                    <Title>  23 - 30 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>22.5</ogc:Literal>
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
                    <Name>30 - 35 ug/m3</Name>
                    <Title>  30 - 35 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>29.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>35</ogc:Literal>
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
                    <Name>35 - 40 ug/m3</Name>
                    <Title>  35 - 40 Goed</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>34.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>40</ogc:Literal>
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
                    <Name>40 - 52  ug/m3</Name>
                    <Title>  40 - 52  Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>39.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>52</ogc:Literal>
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
                    <Name>52 - 64 ug/m3</Name>
                    <Title>  52 - 64 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>51.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>64</ogc:Literal>
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
                    <Name>64 - 76 ug/m3</Name>
                    <Title>  64 - 76 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>63.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>76</ogc:Literal>
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
                    <Name>76 - 88  ug/m3</Name>
                    <Title>  76 - 88 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>75.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>88</ogc:Literal>
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
                    <Name>88 - 100 ug/m3</Name>
                    <Title>  88 - 100 Matig</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>87.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>100</ogc:Literal>
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
                    <Name>100 - 128 ug/m3</Name>
                    <Title>  100 - 128 Onvoldoende</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>99.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>128</ogc:Literal>
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
                    <Name>128 - 156 ug/m3</Name>
                    <Title>  128 - 156 Onvoldoende</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>127.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>156</ogc:Literal>
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
                    <Name>156 - 180 ug/m3</Name>
                    <Title>  156 - 180 Slecht</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>155.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>180</ogc:Literal>
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
                    <Name>180 -200 ug/m3</Name>
                    <Title>  180  - 200 Slecht</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>179.5</ogc:Literal>
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
                    <Name>200 - 240 ug/m3</Name>
                    <Title>  200  - 240 Slecht</Title>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsGreaterThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>199.5</ogc:Literal>
                            </ogc:PropertyIsGreaterThan>
                            <ogc:PropertyIsLessThan>
                                <ogc:PropertyName>sample_value</ogc:PropertyName>
                                <ogc:Literal>240</ogc:Literal>
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
                    <Name>401 - MAX ug/m3</Name>
                    <Title>  &gt; 240 Zeer slecht</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsGreaterThan>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>239.5</ogc:Literal>
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
