/*
 *  Copyright (c) 2020, 2021 Microsoft Corporation
 *
 *  This program and the accompanying materials are made available under the
 *  terms of the Apache License, Version 2.0 which is available at
 *  https://www.apache.org/licenses/LICENSE-2.0
 *
 *  SPDX-License-Identifier: Apache-2.0
 *
 *  Contributors:
 *       Microsoft Corporation - initial API and implementation
 *
 */

plugins {
    `java-library`
}

dependencies {
    implementation(edcLibs.edc.spi.http)
    implementation(edcLibs.edc.spi.oauth2)
    implementation(edcLibs.edc.spi.keys)
    implementation(edcLibs.edc.auth.oauth2.client)
    implementation(edcLibs.edc.core.token)
    implementation(libs.nimbus.jwt)

    testImplementation(edcLibs.edc.junit)

    testImplementation(libs.mockserver.netty)
    testImplementation(libs.mockserver.client)
}


