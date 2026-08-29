//
// Created by grump on 29/08/2026.
//

#include "BackendManager.h"
#include <QCoreApplication>

BackendManager::BackendManager(QObject *parent) : QObject(parent) // Constructor
{
}

void BackendManager::startBackend()
{
    if (m_process != nullptr) {     // Returns if m_process is already pointing at a running process
        return;
    }

    QString scriptPath = QCoreApplication::applicationDirPath() + "/main.py"; // build text string to main.py

    m_process = new QProcess(this);                                     // create QProcess object
    m_process->start("pythonw", QStringList() << scriptPath); // Launch main.py
}

void BackendManager::stopBackend()
{
    if (m_process == nullptr) {     // Returns if m_process isn't pointing at a running process
        return;
    }

    m_process->terminate();                 // Requests program to shut down
    m_process->waitForFinished(3000); // Waits 3 seconds for the backend to stop

    if (m_process->state() != QProcess::NotRunning) { // Kill forcefully if it hasn't closed after 3s
        m_process->kill();
    }

    delete m_process;   // free QProcess from memory
    m_process = nullptr;
}

void BackendManager::restartBackend() { // starts and stops main.py
    stopBackend();
    startBackend();
}