<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>stations</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>SmartEm Stations</Title>
            <Abstract>SmartEm Stations style</Abstract>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>SmartEm Stations (Aktief)</Name>
                    <Title>SmartEm Stations (Aktief)</Title>

                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>value_stale</ogc:PropertyName>
                            <ogc:Literal>0</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>triangle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#00FF66</CssParameter>
                                    <CssParameter name="fill-opacity">0.6</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#660033</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>12</Size>
                        </Graphic>
                    </PointSymbolizer>
                 </Rule>

                <Rule>
                     <Name>SmartEm Stations (Inactief)</Name>
                     <Title>SmartEm Stations (Inactief)</Title>

                     <ogc:Filter>
                         <ogc:PropertyIsEqualTo>
                             <ogc:PropertyName>value_stale</ogc:PropertyName>
                             <ogc:Literal>1</ogc:Literal>
                         </ogc:PropertyIsEqualTo>
                     </ogc:Filter>
                     <PointSymbolizer>
                         <Graphic>
                             <Mark>
                                 <WellKnownName>triangle</WellKnownName>
                                 <Fill>
                                     <CssParameter name="fill">#FF0000</CssParameter>
                                     <CssParameter name="fill-opacity">0.6</CssParameter>
                                 </Fill>
                                 <Stroke>
                                     <CssParameter name="stroke">#660033</CssParameter>
                                     <CssParameter name="stroke-width">1</CssParameter>
                                 </Stroke>
                             </Mark>
                             <Size>12</Size>
                         </Graphic>
                     </PointSymbolizer>
                  </Rule>

            </FeatureTypeStyle>


        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
