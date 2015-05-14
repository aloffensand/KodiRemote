#include <QApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    app.setOrganizationName("KodiRemote");
    app.setApplicationName("KodiRemote");

    QQmlEngine engine;
    QQmlContext *objectContext = new QQmlContext(engine.rootContext());
    QQmlComponent component(&engine, "main.qml");
    QObject *object = component.create(objectContext);
    
    return app.exec();
}
