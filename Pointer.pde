abstract class Pointer<T extends Indicator> extends Indicator {

    T parent;

    PShape shape;

    Pointer(T parent, float x, float y, float h, float w) {
        super(parent.ac, x, y, h, w);

        this.parent = parent;
    }

    abstract void draw();

    abstract void generateBackground();

    abstract void generateMask();

    abstract void generateShape(boolean forMask);

}