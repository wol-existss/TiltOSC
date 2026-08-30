//
// Created by grump on 29/08/2026.
//

#ifndef LAUNCHERAPP_BACKENDMANAGER_H
#define LAUNCHERAPP_BACKENDMANAGER_H

// Required QT headers for compilation
#include <QObject>
#include <QProcess>
#include <QJsonObject>
#include <QJsonDocument>

class BackendManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int receivePort READ receivePort NOTIFY settingsChanged)
    Q_PROPERTY(bool useDigitalLstick READ useDigitalLstick NOTIFY settingsChanged)
    Q_PROPERTY(bool useDigitalRstick READ useDigitalRstick NOTIFY settingsChanged)
    Q_PROPERTY(bool invertYAxis READ invertYAxis NOTIFY settingsChanged)
    Q_PROPERTY(bool controllerEnabled READ controllerEnabled NOTIFY settingsChanged)
    Q_PROPERTY(QString localIp READ localIp CONSTANT) // For determining local IP address
    QString localIp() const;
public:
    explicit BackendManager(QObject *parent = nullptr);
    Q_INVOKABLE void startBackend();
    Q_INVOKABLE void stopBackend();
    Q_INVOKABLE void restartBackend();
    Q_INVOKABLE void saveSettings(int port, bool useLstick, bool useRstick, bool invertY, bool controllerEnabled);

    int receivePort() const { return m_receivePort; }
    bool useDigitalLstick() const { return m_useDigitalLstick; }
    bool useDigitalRstick() const { return m_useDigitalRstick; }
    bool invertYAxis() const { return m_invertYAxis; }
    bool controllerEnabled() const { return m_controllerEnabled; }

    Q_INVOKABLE void loadSettings();

    signals:
        void settingsChanged();

private:
    QProcess *m_process = nullptr;
    int m_receivePort = 4646;
    bool m_useDigitalLstick = false;
    bool m_useDigitalRstick = true;
    bool m_invertYAxis = false;
    bool m_controllerEnabled = true;
};

#endif //LAUNCHERAPP_BACKENDMANAGER_H