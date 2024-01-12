package com.nttdata.gtds.edc.extension.dataplane.annex;

import org.eclipse.edc.connector.dataplane.spi.pipeline.DataTransferExecutorServiceContainer;
import org.eclipse.edc.connector.dataplane.spi.pipeline.PipelineService;
import com.nttdata.gtds.edc.extension.dataplane.annex.sink.RawOutputStreamDataSinkFactory;
import org.eclipse.edc.runtime.metamodel.annotation.Extension;
import org.eclipse.edc.runtime.metamodel.annotation.Inject;
import org.eclipse.edc.spi.system.ServiceExtension;
import org.eclipse.edc.spi.system.ServiceExtensionContext;

@Extension(value = DataPlaneAnnexUtilExtension.NAME)
public class DataPlaneAnnexUtilExtension implements ServiceExtension {
    public static final String NAME = "Data Plane Annex Utilities";

    @Inject
    private PipelineService pipelineService;

    @Inject
    private DataTransferExecutorServiceContainer executorContainer;

    @Override
    public String name() {
        return NAME;
    }

    @Override
    public void initialize(ServiceExtensionContext context) {
        var monitor = context.getMonitor();

        pipelineService.registerFactory(new RawOutputStreamDataSinkFactory(monitor, executorContainer.getExecutorService()));

    }
}
