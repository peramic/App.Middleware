package havis.net.ui.core.client;

import havis.net.ui.middleware.client.mvp.MiddlewareGinjector;
import havis.net.ui.shared.resourcebundle.ResourceBundle;

import org.fusesource.restygwt.client.Defaults;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.FlowPanel;
import com.google.gwt.user.client.ui.RootLayoutPanel;
import com.google.gwt.user.client.ui.Widget;

public class WebUI extends Composite implements EntryPoint {

	@UiField FlowPanel container;

	private ResourceBundle res = ResourceBundle.INSTANCE;
	private havis.net.ui.middleware.client.shared.resourcebundle.ResourceBundle resMiddleware = havis.net.ui.middleware.client.shared.resourcebundle.ResourceBundle.INSTANCE;

	private final MiddlewareGinjector injector = GWT.create(MiddlewareGinjector.class);
	
	private static WebUIUiBinder uiBinder = GWT
			.create(WebUIUiBinder.class);

	interface WebUIUiBinder extends UiBinder<Widget, WebUI> {
	}

	public WebUI() {
		initWidget(uiBinder.createAndBindUi(this));
		
		container.insert(injector.getAppLayout(), 0);
		injector.getPlaceHistoryHandler().handleCurrentHistory();
		ensureInjection();

	}

	@Override
	public void onModuleLoad() {
		Defaults.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
		RootLayoutPanel.get().add(this);
	}
		
	private void ensureInjection() {
		res.css().ensureInjected();
		resMiddleware.css().ensureInjected();
	}
}