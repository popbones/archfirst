This sample shows an issue with JAX-WS when it needs to marshal an object using
an XmlJavaTypeAdapter. The class under question is Position which contains
an attribute of type DecimalQuantity.

public class Position {

    @XmlElement(name = "Quantity", required = true)
    private DecimalQuantity quantity;
    ...

}

DecimalQuantity is annotated with XmlJavaTypeAdapter. So JAXB should use
this adapter to serialize DecimalQuantity.

@XmlJavaTypeAdapter(DecimalQuantityAdapter.class)
public class DecimalQuantity {

    private BigDecimal value;
    ...

}

And finally, here's the adapter for DecimalQuantity. It simply converts
DecimalQuantity to a BigDecimal and vice-versa.

public class DecimalQuantityAdapter extends XmlAdapter<BigDecimal, DecimalQuantity> {

    public DecimalQuantity unmarshal(BigDecimal val) throws Exception {
        return new DecimalQuantity(val);
    }

    public BigDecimal marshal(DecimalQuantity val) throws Exception {
        return val.getValue();
    }
}

This adapter works perfectly fine in a unit test which uses JAXB to serialize
a Position object (see JaxbTest). However, when JAX-WS tries to serialize
the same object in a web service it gets the following exception:

Caused by: javax.xml.bind.JAXBException: class test.DecimalQuantity
           nor any of its super class is known to this context.
	at com.sun.xml.bind.v2.runtime.JAXBContextImpl.getBeanInfo(JAXBContextImpl.java:594)
	at com.sun.xml.bind.v2.runtime.XMLSerializer.childAsXsiType(XMLSerializer.java:648)
	... 45 more

Apparently JAX-WS cannot find the adapter for DecimalQuantity.