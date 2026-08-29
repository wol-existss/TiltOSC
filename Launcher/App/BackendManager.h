//
// Created by grump on 29/08/2026.
//

#ifndef LAUNCHERAPP_BACKENDMANAGER_H
#define LAUNCHERAPP_BACKENDMANAGER_H

// Required QT headers for compilation
#include <QObject>
#include <QProcess>

class BackendManager : public QObject {
    Q_OBJECT

public:
    explicit BackendManager(QObject *parent = nullptr); // Declares constructor for creating BackendManager instances
    Q_INVOKABLE void startBackend(); // Functions for starting and stopping the backend
    Q_INVOKABLE void stopBackend();
    Q_INVOKABLE void restartBackend(); // restart backend function

private:
    QProcess *m_process = nullptr; // Holds running Python backend process so that start/stop can refer to the same instance

};

#endif //LAUNCHERAPP_BACKENDMANAGER_H