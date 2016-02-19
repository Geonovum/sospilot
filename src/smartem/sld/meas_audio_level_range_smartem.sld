<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>Measurements Audio/Noise Level</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>Smart Emission measurements Audio/Noise Level</Title>
            <Abstract>Smart Emission v_last_measurements_audio_max style</Abstract>
            <IsDefault>1</IsDefault>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!--
# level dB(A)
#  1     0-20  zero to quiet room   green
#  2     20-40 up to average residence  blue
#  3     40-80 up to noisy class, alarm clock, police whistle yellow
#  4     80-90 truck with muffler orange
#  5     90-up severe: pneumatic drill, artillery,  red

-->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>0 - 20 dB(A)</Name>
                    <Title>0 - 20 dB(A)</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>1</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#00FF00</CssParameter>
                                    <CssParameter name="fill-opacity">1.0</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">1</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>20-40 dB(A)</Name>
                    <Title>20-40 dB(A)</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>2</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                     </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#0000CC</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">1</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>40-80 dB(A)</Name>
                    <Title>40-80 dB(A)</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                             <ogc:PropertyName>sample_value</ogc:PropertyName>
                             <ogc:Literal>3</ogc:Literal>
                         </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FDD017</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">1</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>80-90 dB(A)</Name>
                    <Title>80-90 dB(A)</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>sample_value</ogc:PropertyName>
                            <ogc:Literal>4</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                     </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#FFA500</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">1</CssParameter>
                                 </Stroke>
                            </Mark>
                            <Size>30</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>90+ dB(A)</Name>
                    <Title>90+ dB(A)</Title>
                     <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                             <ogc:PropertyName>sample_value</ogc:PropertyName>
                             <ogc:Literal>5</ogc:Literal>
                         </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>circle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#CC0000</CssParameter>
                                </Fill>
                                <Stroke>
                                     <CssParameter name="stroke">#FF0066</CssParameter>
                                     <CssParameter name="stroke-width">1</CssParameter>
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
                                <ogc:PropertyName>value_raw</ogc:PropertyName>
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
                            <CssParameter name="fill">#999999</CssParameter>
                        </Fill>

                    </TextSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
